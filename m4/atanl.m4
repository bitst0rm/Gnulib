# atanl.m4 serial 1
dnl Copyright (C) 2010 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN([gl_FUNC_ATANL],
[
  AC_REQUIRE([gl_MATH_H_DEFAULTS])
  dnl Persuade glibc <math.h> to declare atanl().
  AC_REQUIRE([gl_USE_SYSTEM_EXTENSIONS])

  ATANL_LIBM=
  AC_CACHE_CHECK([whether atanl() can be used without linking with libm],
    [gl_cv_func_atanl_no_libm],
    [
      AC_TRY_LINK([#ifndef __NO_MATH_INLINES
                   # define __NO_MATH_INLINES 1 /* for glibc */
                   #endif
                   #include <math.h>
                   long double x;],
                  [return atanl (x) > 1;],
        [gl_cv_func_atanl_no_libm=yes],
        [gl_cv_func_atanl_no_libm=no])
    ])
  if test $gl_cv_func_atanl_no_libm = no; then
    AC_CACHE_CHECK([whether atanl() can be used with libm],
      [gl_cv_func_atanl_in_libm],
      [
        save_LIBS="$LIBS"
        LIBS="$LIBS -lm"
        AC_TRY_LINK([#ifndef __NO_MATH_INLINES
                     # define __NO_MATH_INLINES 1 /* for glibc */
                     #endif
                     #include <math.h>
                     long double x;],
                    [return atanl (x) > 1;],
          [gl_cv_func_atanl_in_libm=yes],
          [gl_cv_func_atanl_in_libm=no])
        LIBS="$save_LIBS"
      ])
    if test $gl_cv_func_atanl_in_libm = yes; then
      ATANL_LIBM=-lm
    fi
  fi
  if test $gl_cv_func_atanl_no_libm = yes \
     || test $gl_cv_func_atanl_in_libm = yes; then
    dnl Also check whether it's declared.
    dnl MacOS X 10.3 has atanl() in libc but doesn't declare it in <math.h>.
    AC_CHECK_DECL([atanl], , [HAVE_DECL_ATANL=0], [#include <math.h>])
  else
    HAVE_DECL_ATANL=0
    HAVE_ATANL=0
    AC_LIBOBJ([atanl])
    AC_REQUIRE([gl_FUNC_ISNANL])
    ATANL_LIBM="$ISNANL_LIBM"
  fi
  AC_SUBST([ATANL_LIBM])
])