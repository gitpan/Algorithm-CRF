/*
  CRF++ -- Yet Another CRF toolkit

  $Id: encoder.h,v 1.9 2006/03/28 18:15:59 taku Exp $;

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
#ifndef _CRFPP_LEANER_H
#define _CRFPP_LEANER_H

#include "common.h"

namespace CRFPP
{
  class Encoder {
  private:
    string_buffer _what;
  public:
    bool learn (const char *, const char *, const char *, bool, size_t, size_t,
		double, double, unsigned short);
    bool convert (const char *, const char*);
    const char* what () { return _what.c_str(); }
  };
}
#endif
