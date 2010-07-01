/*
 * Copyright (C) 2002-2005 Roman Zippel <zippel@linux-m68k.org>
 * Copyright (C) 2002-2005 Sam Ravnborg <sam@ravnborg.org>
 *
 * Released under the terms of the GNU GPL v2.0.
 */

#include <string.h>
#include "lkc.h"

struct dir *dir_lookup(const char *name)
{
	struct dir *dir;

	for (dir = dir_list; dir; dir = dir->next)
		if (!strcmp(name, dir->name))
			return dir;

	dir = malloc(sizeof(*dir));
	dir->name = strdup(name);
	dir->enabled = 0;
	dir->next = dir_list;
	dir_list = dir;

	return dir;
}

/* file already present in list? If not add it */
struct file *file_lookup(const char *name)
{
	struct file *file;
	char *last_slash;

	for (file = file_list; file; file = file->next) {
		if (!strcmp(name, file->name))
			return file;
	}

	file = malloc(sizeof(*file));
	memset(file, 0, sizeof(*file));
	file->name = strdup(name);

	last_slash = strrchr(file->name, '/');
	if (last_slash) {
		*last_slash = '\0';
		file->dir = dir_lookup(file->name);
		*last_slash = '/';
	} else
		file->dir = dir_lookup("");
	file->next = file_list;
	file_list = file;
	return file;
}

struct cross_dir_data {
	FILE *out;
	struct symbol *sym;
	int printed;
};

static void print_build_dir(void *cookie, struct symbol *sym, const char *name)
{
	struct cross_dir_data *d = cookie;

	if (!sym || !sym->file || !sym->file->dir->name[0]
	    || !sym->file->dir->enabled || d->sym->file->dir == sym->file->dir)
		return;

	if (!d->printed)
		fprintf(d->out, "%s/staging: ", d->sym->file->dir->name);

	fprintf(d->out, "%s/staging ", sym->file->dir->name);
	++d->printed;
}

static void print_build_deps(FILE *out, struct symbol *sym)
{
	struct cross_dir_data d;
	struct property *prop;

	if (!sym->file || sym->file->dir->name[0] == '\0'
	    || !sym->file->dir->enabled)
		return;

	d.out = out;
	d.sym = sym;
	d.printed = 1;

	d.printed = 0;
	for (prop = sym->prop; prop; prop = prop->next) {
		switch (prop->type) {
		case P_BUILD_SELECT:
			if (!expr_calc_value(prop->visible.expr))
				break;
			/* Fallback wanted */
		case P_BUILD_DEPENDS:
			expr_print(prop->expr, print_build_dir, &d, E_NONE);
			break;
			/* Avoid gcc warning */
		default:
			break;
		}
	}

	if (d.printed)
		putc('\n', out);
}

/* write a dependency file as used by kbuild to track dependencies */
int file_write_dep(const char *name)
{
	struct symbol *sym, *env_sym;
	struct expr *e;
	struct file *file;
	FILE *out;
	int i;

	if (!name)
		name = ".kconfig.d";
	out = fopen("..config.tmp", "w");
	if (!out)
		return 1;
	fprintf(out, "deps_config := \\\n");
	for (file = file_list; file; file = file->next) {
		if (file->next)
			fprintf(out, "\t%s \\\n", file->name);
		else
			fprintf(out, "\t%s\n", file->name);
	}
	fprintf(out, "\n%s: \\\n"
		     "\t$(deps_config)\n\n", conf_get_autoconfig_name());

	expr_list_for_each_sym(sym_env_list, e, sym) {
		struct property *prop;
		const char *value;

		prop = sym_get_env_prop(sym);
		env_sym = prop_get_symbol(prop);
		if (!env_sym)
			continue;
		value = getenv(env_sym->name);
		if (!value)
			value = "";
		fprintf(out, "ifneq \"$(%s)\" \"%s\"\n", env_sym->name, value);
		fprintf(out, "%s: FORCE\n", conf_get_autoconfig_name());
		fprintf(out, "endif\n");
	}

	fprintf(out, "\n$(deps_config): ;\n\n"
		"all_packages :=\n"
		"packages :=\n"
		"srcdirs =\n");

	for_all_symbols(i, sym) {
		struct property *prop;
		tristate value;

		prop = sym_get_pkg_prop(sym);
		if (!prop)
			continue;

		fprintf(out, "all_packages += %s\n", prop->file->dir->name);
		value = sym_get_tristate_value(sym);
		if (value == yes) {
			fprintf(out, "packages += %s\n", prop->file->dir->name);
			prop->file->dir->enabled = 1;
		}

		putc('\n', out);
	}


	for_all_symbols(i, sym) {
		struct property *prop;

		prop = sym_get_srcdir_prop(sym);
		if (!prop)
			goto not_srcdir;

		fprintf(out, "%s/srcdir = $(call mksrcdir,$(MKR_%s))\n",
			prop->file->dir->name, sym->name);
		fprintf(out, "%s/srcdir-var = MKR_%s\n\n",
			prop->file->dir->name, sym->name);
		continue;

	  not_srcdir:
		if ((sym->type == S_BOOLEAN
		     || sym->type == S_TRISTATE)
		    && (sym_get_tristate_value(sym) == mod
			|| sym_get_tristate_value(sym) == yes))
			print_build_deps(out, sym);
	}

	fclose(out);
	rename("..config.tmp", name);
	return 0;
}


/* Allocate initial growable sting */
struct gstr str_new(void)
{
	struct gstr gs;
	gs.s = malloc(sizeof(char) * 64);
	gs.len = 64;
	strcpy(gs.s, "\0");
	return gs;
}

/* Allocate and assign growable string */
struct gstr str_assign(const char *s)
{
	struct gstr gs;
	gs.s = strdup(s);
	gs.len = strlen(s) + 1;
	return gs;
}

/* Free storage for growable string */
void str_free(struct gstr *gs)
{
	if (gs->s)
		free(gs->s);
	gs->s = NULL;
	gs->len = 0;
}

/* Append to growable string */
void str_append(struct gstr *gs, const char *s)
{
	size_t l;
	if (s) {
		l = strlen(gs->s) + strlen(s) + 1;
		if (l > gs->len) {
			gs->s   = realloc(gs->s, l);
			gs->len = l;
		}
		strcat(gs->s, s);
	}
}

/* Append printf formatted string to growable string */
void str_printf(struct gstr *gs, const char *fmt, ...)
{
	va_list ap;
	char s[10000]; /* big enough... */
	va_start(ap, fmt);
	vsnprintf(s, sizeof(s), fmt, ap);
	str_append(gs, s);
	va_end(ap);
}

/* Retrieve value of growable string */
const char *str_get(struct gstr *gs)
{
	return gs->s;
}
