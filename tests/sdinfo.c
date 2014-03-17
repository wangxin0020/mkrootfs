#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <errno.h>

#include <unistd.h>
#include <fcntl.h> 
#include <sys/ioctl.h>
#include <scsi/sg.h>

int sdinfo(char *buffer, size_t len, const char *dev)
{
	uint8_t cmd[6] = { 0x12, 0, 0, 0, 0, 0 };
	uint8_t sense[64];
	uint8_t resp[36];
	struct sg_io_hdr arg;
	int rc, fd;
	
	rc = open(dev, O_RDONLY|O_NONBLOCK);
	if (rc < 0) {
		rc = -errno;
		fprintf(stderr, "open(%s): %m\n", dev);
		return rc;
	}
	fd = rc;

	cmd[4] = sizeof(resp);
	memset(&arg, '\0', sizeof(arg));
	arg.interface_id = 'S';
	arg.dxfer_direction = SG_DXFER_FROM_DEV;
	arg.dxferp = resp;
	arg.dxfer_len = sizeof(resp);
	arg.cmdp = cmd;
	arg.cmd_len = sizeof(cmd);
	arg.sbp = sense;
	arg.mx_sb_len = sizeof(sense);

	rc = ioctl(fd, SG_IO, &arg);
	if (rc < 0) {
		rc = -errno;
		fprintf(stderr, 
			"ioctl(%s, SG_IO, SG_DXFER_FROM_DEV): %m\n", dev);
		goto err;
	}

	if (len > 29)
		len = 29;
	memcpy(buffer, resp + 8, len - 1);
	buffer[len - 1] = '\0';

	rc = 0;
  err:
	close(fd);
	return rc;
}

int main(int argc, const char *argv[])
{
	char buffer[26];
	int rc;

	if (argc != 2)
		return EXIT_FAILURE;

	rc = sdinfo(buffer, sizeof(buffer) - 1, argv[1]);
	if (rc < 0)
		return EXIT_FAILURE;

	memmove(buffer + 9, buffer + 8, 16);
	buffer[8] = ' ';

	printf("%s\n", buffer);
	
	return EXIT_SUCCESS;
}
