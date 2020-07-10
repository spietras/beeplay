#ifndef POSIX_H
#define POSIX_H

/* 
** Enable POSIX support
** credit: https://stackoverflow.com/a/3875233/12861599
*/

#if !defined(_XOPEN_SOURCE) && !defined(_POSIX_C_SOURCE)
#if defined(__cplusplus)
#define _XOPEN_SOURCE 700   /* SUS v4, POSIX 1003.1 2008/13 (POSIX 2008/13) */
#elif __STDC_VERSION__ >= 199901L
#define _XOPEN_SOURCE 700   /* SUS v4, POSIX 1003.1 2008/13 (POSIX 2008/13) */
#else
#define _XOPEN_SOURCE 500   /* SUS v2, POSIX 1003.1 1997 */
#endif /* __STDC_VERSION__ */
#endif /* !_XOPEN_SOURCE && !_POSIX_C_SOURCE */

#endif /* POSIX_H */