#ifndef __stdio_h__
#define __stdio_h__

#ifndef _SIZE_T_DEFINED
typedef unsigned int size_t;
#define _SIZE_T_DEFINED
#endif

#ifndef _WCHAR_T_DEFINED
typedef unsigned short wchar_t;
#define _WCHAR_T_DEFINED
#endif


#ifndef _WCTYPE_T_DEFINED
typedef wchar_t wint_t;
typedef wchar_t wctype_t;
#define _WCTYPE_T_DEFINED
#endif


#ifndef _VA_LIST_DEFINED
typedef char *	va_list;
#define _VA_LIST_DEFINED
#endif


#define BUFSIZ	512
#ifndef MAX_PATH
#define MAX_PATH	260
#endif

#ifndef MAX_FNAME
#define MAX_FNAME	256
#endif


/*
 * Number of supported streams. _NFILE is confusing and obsolete, but
 * supported anyway for backwards compatibility.
 */
#define _NSTREAM_   20

#define EOF	(-1)


#ifndef _FILE_DEFINED
struct _iobuf {
	char *_ptr;
	int   _cnt;
	char *_base;
	int   _flag;
	int   _file;
	int   _charbuf;
	int   _bufsiz;
	char *_tmpfname;
	};
typedef struct _iobuf FILE;
#define _FILE_DEFINED
#endif


/* Directory where temporary files may be created. */

#define _P_tmpdir   "\\"
#define _wP_tmpdir  L"\\"


#define L_tmpnam sizeof(_P_tmpdir)+12

/* Seek method constants */

#define SEEK_CUR    1
#define SEEK_END    2
#define SEEK_SET    0


#define FILENAME_MAX	260
#define FOPEN_MAX	20
#define _SYS_OPEN	20
#define TMP_MAX 	32767


/* Define NULL pointer value */

#ifndef NULL
#define NULL	((void *)0)
#endif


/* Declare _iob[] array */

extern FILE *_iob;


/* Define file position type */

#ifndef _FPOS_T_DEFINED
typedef long fpos_t;
#define _FPOS_T_DEFINED
#endif

extern FILE (*_imp___iob)[];
#define _iob    (*_imp___iob)
#define stdin  (&_iob[0])
#define stdout (&_iob[1])
#define stderr (&_iob[2])

#define _IOREAD 	0x0001
#define _IOWRT		0x0002

#define _IOFBF		0x0000
#define _IOLBF		0x0040
#define _IONBF		0x0004

#define _IOMYBUF	0x0008
#define _IOEOF		0x0010
#define _IOERR		0x0020
#define _IOSTRG 	0x0040
#define _IORW		0x0080
#define	_IOAPPEND	0x0200


/* Function prototypes */


int _filbuf(FILE *);
int flsbuf(int, FILE *);

FILE * _fsopen(const char *, const char *, int);

void clearerr(FILE *);
int fclose(FILE *);
int _fcloseall(void);

FILE * fdopen(int, const char *);

int feof(FILE *);
int ferror(FILE *);
int fflush(FILE *);
int fgetc(FILE *);
wchar_t fgetwc(FILE *);
wchar_t getwc(FILE *);
#define getwc fgetwc
int _fgetchar(void);
int fgetpos(FILE *, fpos_t *);
char * fgets(char *, int, FILE *);

int fileno(FILE *);
#define _fileno fileno

int _flushall(void);
FILE * fopen(const char *, const char *);
int fprintf(FILE *, const char *, ...);
int xfprintf(FILE *,const char *,...);
int fputc(int, FILE *);
int _fputchar(int);
int fputs(const char *, FILE *);
size_t fread(void *, size_t, size_t, FILE *);
FILE * freopen(const char *, const char *, FILE *);
int fscanf(FILE *, const char *, ...);
int fsetpos(FILE *, const fpos_t *);
int fseek(FILE *, long, int);
long ftell(FILE *);
size_t fwrite(const void *, size_t, size_t, FILE *);
int getc(FILE *);
int getchar(void);
char * gets(char *);
int _getw(FILE *);
int _pclose(FILE *);
#define pclose _pclose
FILE * popen(const char *, const char *);
#define _popen popen
int printf(const char *, ...);
int xprintf(const char *,...);
int dprintf(const char *, ...);
int putc(int, FILE *);
int putchar(int);
int puts(const char *);
int _putw(int, FILE *);
int remove(const char *);
int rename(const char *,const char *);
void rewind(FILE *);
int _rmtmp(void);
int scanf(const char *, ...);
void setbuf(FILE *, char *);
int setvbuf(FILE *, char *, int, size_t);
int _snprintf(char *, size_t, const char *, ...);
int sprintf(char *, const char *, ...);
int xsprintf(char *, const char *, ...);
int snprintf(char *,size_t,const char *,...);
int xsnprintf(char *,size_t,const char *,...);
int sscanf(const char *, const char *, ...);
int xsscanf(const char *, const char *, ...);
char * _tempnam(char *, char *);
FILE * tmpfile(void);
char * tmpnam(char *);
char *tempnam(char *,char *);
int ungetc(int, FILE *);
int _unlink(const char *);
#define unlink _unlink
int vfprintf(FILE *, const char *, va_list);
int vprintf(const char *, va_list);
int _vsnprintf(char *, size_t, const char *, va_list);
int _vsnwprintf(wchar_t *, size_t, const wchar_t *, va_list);
int vsnprintf(char *,size_t,const char *,va_list);
int xvsnprintf(char *,size_t,const char *,va_list);
int xvsnprintf(char *,size_t,const char *,va_list);
int vsprintf(char *, const char *, va_list);
int xvsprintf(char *, const char *, va_list);
void perror(char *);
void _wperror(const wchar_t *);
#include <_syslist.h>
#ifndef STD_INPUT_HANDLE
#define STD_INPUT_HANDLE   ((unsigned long)-10)
#define STD_OUTPUT_HANDLE ((unsigned long)-11)
#define STD_ERROR_HANDLE  ((unsigned long)-12)
#endif
#endif	/* _INC_STDIO */
