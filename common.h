/*
  CRF++ -- Yet Another CRF toolkit

  $Id: common.h,v 1.11 2006/03/28 00:26:54 taku Exp $;

  Copyright (C) 2005 Taku Kudo <taku@chasen.org>

  This is free software with ABSOLUTELY NO WARRANTY.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307	USA
*/
#ifndef _CRFPP_COMMON_H
#define _CRFPP_COMMON_H

#include <string>
#include <cstring>
#include <algorithm>

#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#define COPYRIGHT  "CRF++: Yet Another CRF Tool Kit\nCopyright (C) 2005-2006 Taku Kudo, All rights reserved.\n"
#define MODEL_VERSION 100

#if defined (_WIN32) && !defined (__CYGWIN__)
# define OUTPUT_MODE std::ios::binary|std::ios::out
#else
# define OUTPUT_MODE std::ios::out
#endif

#define WHAT(msg) _what.assign(""), _what << __FILE__ << "(" << __LINE__ << "): " << msg;
#define WHAT_CLOSE_FALSE(msg) do { WHAT(msg); this->close(); return false; } while (0)
#define WHAT_FALSE(msg)	      do { WHAT(msg); return false; } while (0)

namespace CRFPP
{
  template <class T> inline T _min (T x, T y) { return (x < y) ? x : y; }
  template <class T> inline T _max (T x, T y) { return (x > y) ? x : y; }

  template <class Iterator>
  static inline size_t tokenize (char *str,
				 const char *del, Iterator out, size_t max)
  {
    char *stre = str + strlen (str);
    const char *dele = del + strlen (del);
    size_t size = 0;

    while (size < max) {
      char *n = std::find_first_of (str, stre, del, dele);
      *n = '\0';
      *out++ = str;
      ++size;
      if (n == stre) break;
      str = n + 1;
    }

    for (unsigned int i = size; i < max; ++i)
      *out++ = (char *)"";
    return size;
  }

  void inline dtoa (double val, char *s)
  {
    std::sprintf(s, "%-16f", val);
    char *p = s;
    for (; *p != ' '; ++p) {};
    *p = '\0';
    return;
  }

  template <class T>
  inline void itoa (T val, char *s)
  {
    char *t;
    T mod;

    if(val < 0) {
      *s++ = '-';
      val = -val;
    }
    t = s;

    while (val) {
      mod = val % 10;
      *t++ = (char)mod + '0';
      val /= 10;
    }

    if (s == t) *t++ = '0';
    *t = '\0';
    std::reverse (s, t);

    return;
  }

  template <class T>
  inline void uitoa (T val, char *s)
  {
    char *t;
    T mod;
    t = s;

    while(val) {
      mod = val % 10;
      *t++ =(char)mod + '0';
      val /= 10;
    }

    if (s == t) *t++ = '0';
    *t = '\0';
    std::reverse (s, t);

    return;
  }

#define _ITOA(_n)  char buf[64]; itoa (_n, buf); append(buf); return *this;
#define _UITOA(_n) char buf[64]; uitoa(_n, buf); append(buf); return *this;
#define _DTOA(_n)  char buf[64]; dtoa (_n, buf); append(buf); return *this;

  class string_buffer: public std::string
  {
  public:
    string_buffer& operator<< (double _n)             { _DTOA(_n); }
    string_buffer& operator<< (short int _n)          { _ITOA(_n); }
    string_buffer& operator<< (int _n)                { _ITOA(_n); }
    string_buffer& operator<< (long int _n)           { _ITOA(_n); }
    string_buffer& operator<< (unsigned short int _n) { _UITOA(_n); }
    string_buffer& operator<< (unsigned int _n)       { _UITOA(_n); }
    string_buffer& operator<< (unsigned long int _n)  { _UITOA(_n); }
    string_buffer& operator<< (char _n)               { push_back(_n); return *this; }
    string_buffer& operator<< (const char* _n)        { append(_n); return *this; }
    string_buffer& operator<< (const std::string& _n) { append(_n); return *this; }
  };
}

#endif
