#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>

#include <unistd.h>
#include <sys/stat.h>

#include <search.h>

void usage(const char *progname)
{
	printf("%s basedir list fakeroot-state\n"
		"copies fakeroot-state to stdout, keeping only files in the\n"
		"\"list\" file under the \"basedir\" directory\n",
		progname);
}

static int compar(const void *first, const void *second)
{
	long f = (long)first, s = (long)second;

	if (f < s)
		return -1;
	if (f > s)
		return 1;
	return 0;
}

int main(int argc, const char *argv[])
{
	const char *basedir;
	char *p, *filename;
	char buffer[256];
	void *troot = NULL;
	FILE *list;
	long len;
	int rc;

	if (argc != 4) {
		usage(argv[0]);
		exit(EXIT_FAILURE);
	}

	basedir = argv[1];

	list = fopen(argv[2], "r");
	if (list == NULL) {
		perror("fopen");
		exit(EXIT_FAILURE);
	}

	len = pathconf(basedir, _PC_PATH_MAX);
	if (len == -1)
		len = 256;
	filename = malloc(len);
	if (filename == NULL) {
		fprintf(stderr, "malloc failed\n");
		exit(EXIT_FAILURE);
	}

	p = filename + strlen(basedir);
	memcpy(filename, basedir, p - filename);
	*p++ = '/';
	while (fgets(p, len - (p - filename), list)) {
		unsigned namelen = strlen(filename) - 1;
		struct stat sb;
		void *key;

		filename[namelen] = '\0';

		rc = lstat(filename, &sb);
		if (rc < 0) {
			if (errno == ENOENT)
				continue;
			fprintf(stderr, "lstat(%s): %m");
			exit(EXIT_FAILURE);
		}

		key = (void *)(long)sb.st_ino;

		if (tfind(key, &troot, compar)) {
			fprintf(stderr, "Duplicate inode number %ld\n",
				(long)sb.st_ino);
			exit(EXIT_FAILURE);
		}
		tsearch(key, &troot, compar);
	}
	fclose(list);

	list = fopen(argv[3], "r");
	if (list == NULL) {
		perror("fopen");
		exit(EXIT_FAILURE);
	}
	while (fgets(buffer, sizeof(buffer), list)) {
		long dev, ino;

		if (sscanf(buffer, "dev=%lx,ino=%ld", &dev, &ino) != 2) {
			fprintf(stderr, "Parse error at %s", buffer);
			exit(EXIT_FAILURE);
		}

		if (tfind((void *)ino, &troot, compar))
			printf("%s", buffer);
	}
	fclose(list);

	return EXIT_SUCCESS;
}
