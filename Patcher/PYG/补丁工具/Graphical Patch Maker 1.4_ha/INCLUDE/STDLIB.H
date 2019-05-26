/*
 * stdlib.h  Definitions for common types, variables, and functions.  */

#ifndef __stdlib_h__
#define __stdlib_h__
#include <stddef.h>
#include <_syslist.h>
#define _MAX_PATH 260
#define _MAX_FNAME	256
#define _MAX_EXT	256
#define _MAX_DRIVE	3
#define _MAX_DIR	256
#define RAND_MAX 0x7FFF
typedef struct {
  int quot; /* quotient */
  int rem; /* remainder */
} div_t;

typedef struct {
  long quot; /* quotient */
  long rem; /* remainder */
} ldiv_t;
#ifndef max
#define max(a,b)    (((a) > (b)) ? (a) : (b))
#define min(a,b)    (((a) < (b)) ? (a) : (b))
#endif
#ifndef NULL
#define NULL ((void *)0)
#endif
#ifndef _WCHAR_T_DEFINED
typedef unsigned short wchar_t;
#define _WCHAR_T_DEFINED
#endif
#ifndef EXIT_FAILURE
#define EXIT_FAILURE 1
#define EXIT_SUCCESS 0
#endif
#ifndef RAND_MAX
#define RAND_MAX 0x7fff
#endif
#define _OUT_TO_DEFAULT	0
#define _OUT_TO_STDERR	1
#define _OUT_TO_MSGBOX	2
#define _REPORT_ERRMODE	3
void	abort(void);
int	abs(int);
int	atexit(void (*_func)(void));
double	atof(char *_nptr);
int	atoi(char *_nptr);
/*long long atoll(char *str);*/
char    *itoa(int,char *,int);
char    *_i64toa(long long,char *,int);
char    *_ui64toa(unsigned long long,char *,int);
long long _atoi64(const char *);
#define atoi64	_atoi64
char	*ltoa(long,char *,int);
char    *_ultoa(unsigned long,char *,int);
unsigned short   *_ultow(unsigned long,unsigned short *,int);
#define ultoa _ultoa
#define ultow _ultow
long	atol(char *_nptr);
void *	bsearch(const void * _key,void * _base, size_t _nmemb, size_t _size,
		       int (*_compar)(const void *,const void *));
void *	calloc(size_t _nmemb, size_t _size);
div_t	div(int _numer, int _denom);
void	exit(int _status);
void	_exit(int status);
void	free(void *);
char	*_fullpath( char *absPath, const char *relPath, size_t maxLength );
void _makepath(char *path, const char *drive, const char *dir, const char *fname, const char *ext );
void _splitpath(const char*, char*, char*, char*, char*);
char *  getenv(const char *_string);
long	labs(long);
ldiv_t	ldiv(long _numer, long _denom);
void *	malloc(size_t _size);
unsigned long _lrotl(unsigned long,int);
unsigned long _rotl(unsigned int,int);
void	qsort(void * _base, size_t _nmemb, size_t _size, int(*_compar)(const void *, const void *));
int	rand(void);
void *	realloc(void * _r, size_t _size);
void	srand(unsigned _seed);
double	strtod(const char *_n, char **_endvoid);
long double strtold(const char *,char **);
long	strtol(const char *_n, char **_endvoid, int _base);
unsigned long strtoul(const char *_n, char **_end, int _base);
int	system(const char *_string);
int	putenv(char *_string);
int	setenv(char *_string, char *_value, int _overwrite);
char *	_gcvt(double,int,char *);
char *	_fcvt(double,int,int *,int *);
char *	_ecvt(double,int,int *,int *);
int     mbstowcs(unsigned short *,char *,int);
size_t wcstombs( char *mbstr, const unsigned short *wcstr, size_t count );
int	mblen(char *,int);
int	mbstrlen(char *s);
extern int _sleep(unsigned long);
#define sleep _sleep
#define	_mbstrlen mbstrlen
#define CRTAPI1
#define _fmode *(_imp___fmode_dll)
extern int _fmode;
extern char ***_imp___environ_dll;
#define _environ (*_imp___environ_dll)
extern unsigned int _osver;
extern unsigned int *(_imp___osver);
#define _osver *(_imp___osver)
extern unsigned int _winmajor;
extern unsigned int *(_imp___winmajor);
#define _winmajor *(_imp___winmajor)
extern unsigned int _winminor;
extern unsigned int *(_imp___winminor);
#define _winminor *(_imp___winminor)
extern unsigned int _winver;
extern unsigned int *(_imp___winver);
#define _winver *(_imp___winver)
void _searchenv(char *,char *,char *);
wchar_t *  _itow (int, wchar_t *, int);
wchar_t *  _ltow (long, wchar_t *, int);
unsigned short *  _ultow (unsigned long, unsigned short *, int);
double  wcstod(const wchar_t *, wchar_t **);
long    wcstol(const wchar_t *, wchar_t **, int);
unsigned long  wcstoul(const wchar_t *, wchar_t **, int);
wchar_t *  _wgetenv(const wchar_t *);
int     _wsystem(const wchar_t *);
int  _wtoi(const wchar_t *);
long  _wtol(const wchar_t *);
#endif /* _STDLIB_H_ */
