#ifndef _CTYPE_H_
#define _CTYPE_H_

int isalnum (int c);
int isalpha (int c);
int iscntrl (int c);
int isdigit (int c);
int isgraph (int c);
int islower (int c);
int isprint (int c);
int ispunct (int c);
int isspace (int c);
int isupper (int c);
int isxdigit(int c);
int tolower (int c);
int toupper (int c);

int isascii (int c);
int toascii (int c);
int _tolower (int c);
int _toupper (int c);
int iscsym(int);
int iscsymf(int);

#define	_UPPER		1
#define	_LOWER		2
#define	_DIGIT		4
#define	_SPACE		8
#define _PUNCT		16
#define _CONTROL	32
#define _HEX		0x80
#define	_BLANK		0x40

extern	unsigned char	_ctype[];

#define	isalpha(c)	((_ctype+1)[c]&(_UPPER|_LOWER))
#define	isupper(c)	((_ctype+1)[c]&_UPPER)
#define	islower(c)	((_ctype+1)[c]&_LOWER)
#define	isdigit(c)	((_ctype+1)[c]&_DIGIT)
#define	isxdigit(c)	((_ctype+1)[c]&(_HEX|_DIGIT))
#define	isspace(c)	((_ctype+1)[c]&_SPACE)
#define ispunct(c)	((_ctype+1)[c]&_PUNCT)
#define isalnum(c)	((_ctype+1)[c]&(_UPPER|_LOWER|_DIGIT))
#define isprint(c)	((_ctype+1)[c]&(_PUNCT|_UPPER|_LOWER|_DIGIT|_BLANK))
#define	isgraph(c)	((_ctype+1)[c]&(_PUNCT|_UPPER|_LOWER|_DIGIT))
#define iscntrl(c)	((_ctype+1)[c]&_CONTROL)

#define isascii(c)	((unsigned)(c)<=0177)
#define toascii(c)	((c)&0177)

#endif /* _CTYPE_H_ */
