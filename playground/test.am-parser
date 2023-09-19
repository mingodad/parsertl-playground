SUBDIRS = . tests

# Plugin UI file
plugin_uidir = $(anjuta_ui_dir)
dist_plugin_ui_DATA =

# Plugin glade file
plugin_gladedir = $(anjuta_glade_dir)
dist_plugin_glade_DATA =

# Plugin icon file
plugin_pixmapsdir = $(anjuta_image_dir)
dist_plugin_pixmaps_DATA = am-project-plugin-48.png

# Plugin description file
plugin_in_files = am-project.plugin.in
%.plugin: %.plugin.in $(INTLTOOL_MERGE) $(wildcard $(top_srcdir)/po/*po) ; $(INTLTOOL_MERGE) $(top_srcdir)/po $< $@ -d -u -c $(top_builddir)/po/.intltool-merge-cache

plugindir = $(anjuta_plugin_dir)
dist_plugin_DATA = $(plugin_in_files:.plugin.in=.plugin)

AM_CPPFLAGS = 					\
	$(WARN_CFLAGS) \
	$(DEPRECATED_FLAGS) \
	$(GIO_CFLAGS) \
	$(LIBANJUTA_CFLAGS) \
	-DG_LOG_DOMAIN=\"am-project\"

# flex(1) output fails this check, so disable it
CFLAGS += -Wno-error=missing-prototypes

plugin_LTLIBRARIES = \
	libam-project.la

libam_project_la_SOURCES = \
	plugin.c \
	plugin.h \
	am-project.c \
	am-project.h \
	am-scanner.l \
	am-parser.y \
	am-scanner.h \
	ac-scanner.l \
	ac-parser.y \
	ac-scanner.h \
	ac-writer.h \
	ac-writer.c \
	am-writer.h \
	am-writer.c \
	am-project-private.h \
	am-properties.c \
	am-properties.h \
	amp-node.c \
	amp-node.h \
	amp-root.c \
	amp-root.h \
	amp-module.h \
	amp-module.c \
	amp-package.h \
	amp-package.c \
	amp-group.h \
	amp-group.c \
	amp-target.h \
	amp-target.c \
	amp-source.h \
	amp-source.c \
	amp-object.c \
	amp-object.h \
	command-queue.c \
	command-queue.h

libam_project_la_LDFLAGS = $(ANJUTA_PLUGIN_LDFLAGS)

libam_project_la_LIBADD = \
	$(GIO_LIBS) \
	$(LIBANJUTA_LIBS)

AM_YFLAGS = -t -v -g -rall -r lookahead,itemset

ac-scanner.c: $(srcdir)/ac-scanner.l ac-parser.c
	$(LEXCOMPILE) -o $@ $<

ac-parser.c: $(srcdir)/ac-parser.y
	$(YACCCOMPILE) -o $@ $<

ac-scanner.h: ac-parser.c

am-scanner.c: $(srcdir)/am-scanner.l am-parser.c
	$(LEXCOMPILE) -o $@ $<

am-parser.c: $(srcdir)/am-parser.y
	$(YACCCOMPILE) -o $@ $<

am-scanner.h: am-parser.c

# Test program

noinst_PROGRAMS = projectparser

projectparser_SOURCES = \
	projectparser.c \
	$(libam_project_la_SOURCES)

# This is needed to have different objects for libam_project_la_SOURCES, one
# compiled with libtool another without
projectparser_CFLAGS = $(AM_CFLAGS)

projectparser_LDADD = \
	$(GIO_LIBS) \
	$(LIBANJUTA_LIBS) \
	$(ANJUTA_LIBS)

EXTRA_DIST = \
	$(plugin_in_files) \
	ac-parser.h \
	am-parser.h

CLEANFILES = $(plugin_in_files:.plugin.in=.plugin)

DISTCLEANFILES = \
	$(plugin_DATA)

-include $(top_srcdir)/git.mk
