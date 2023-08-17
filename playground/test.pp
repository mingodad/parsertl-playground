/*

This file must be translated to C and modified to build everywhere.

See the adjacent README.txt file for instructions.

*/

/* to workaround https://bugs.llvm.org/show_bug.cgi?id=43465 */
#if defined(__clang__)
#pragma clang diagnostic push
#if defined(__has_warning)
#if __has_warning("-Wimplicit-fallthrough")
#pragma clang diagnostic ignored "-Wimplicit-fallthrough"
#endif
#endif
#elif defined(__GNUC__) && (__GNUC__ >= 7)
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wimplicit-fallthrough"
#endif

/* We do not care of interactive mode */
#define YY_NEVER_INTERACTIVE 1

/* Do not include unistd.h in generated source. */
#define YY_NO_UNISTD_H

/* Skip declaring this function.  It is a macro.  */
#define YY_SKIP_YYWRAP

#ifdef _WIN32
#pragma warning(disable : 4018)
#pragma warning(disable : 4127)
#pragma warning(disable : 4131)
#pragma warning(disable : 4244)
#pragma warning(disable : 4251)
#pragma warning(disable : 4267)
#pragma warning(disable : 4305)
#pragma warning(disable : 4309)
#pragma warning(disable : 4706)
#pragma warning(disable : 4786)
#endif

#define SKIP_MATCH_MAXLEN 15

/*
 * Skip ahead until one of the strings is found,
 * then skip to the end of the line.
 * Return 0 if no match found.
 */
static int skip_comment(void);
static int skip_trailing_comment(const char* text, size_t l);
static int skip_ahead_multi(const char* strings[]);
static int skip_ahead_until(const char* text);
static int skip_to_next_directive(void);
static int skip_conditional_block(void);

static void doxygen_comment(void);
static void doxygen_cpp_comment(void);
static void doxygen_group_start(void);
static void doxygen_group_end(void);
static void vtk_comment(void);
static void vtk_name_comment(void);
static void vtk_section_comment(void);
static void cpp_comment_line(void);
static void blank_line(void);

static const char* raw_string(const char* begin);

static void preprocessor_directive(const char* text, size_t l);
static void print_preprocessor_error(int result, const char* cp, size_t n);
static char* get_macro_arguments(void);
static void skip_macro_arguments(void);

static void push_buffer(void);
static int pop_buffer(void);

static void push_include(const char* filename);
static void pop_include(void);

static void push_macro(MacroInfo* macro);
static void pop_macro(void);
static int in_macro(void);