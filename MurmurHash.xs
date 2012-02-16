/*
 * Perl XS for the Digest::Murmur Module
 */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"
#include <string.h>
#include <stdint.h>

#include "MurmurHash1.cpp"
#include "MurmurHash3.cpp"

U32
murmur_hash_old(char *data, size_t len) {
  const uint32_t m  =  0x5bd1e995;
  const uint8_t r   =  16;
  uint32_t length   =  len;
  uint32_t h        =  length * m;

  while (length >= 4) {
    h += *(unsigned int *)data;
    h *= m;
    h ^= h >> r;
    data += 4;
    length -= 4;
  }

  switch (length) {
    case 3:
      h += data[2] << 16;
    case 2:
      h += data[1] << 8;
    case 1:
      h += data[0];
      h *= m;
      h ^= h >> r;
  }

  h *= m;
  h ^= h >> 10;
  h *= m;
  h ^= h >> 17;

  return h;
}



MODULE = Digest::MurmurHash	PACKAGE = Digest::MurmurHash

PROTOTYPES: ENABLE


SV*
murmur_hash(sv)
  SV *sv
PREINIT:
  char *str;
  uint32_t reslt;
  STRLEN len;
CODE:
  if (SvROK(sv))
    sv = SvRV(sv);
  if (! SvOK(sv))
    XSRETURN_NO;
  str = SvPVbyte(sv, len);
  if (! len)
    XSRETURN_NO;
  reslt = murmur_hash_old(str, len);
  RETVAL = newSVuv(reslt);
OUTPUT:
  RETVAL


SV*
murmurhash1(sv, seed)
  SV *sv
  U32 seed
PREINIT:
  char *str;
  uint32_t reslt;
  STRLEN len;
CODE:
  if (SvROK(sv))
    sv = SvRV(sv);
  if (! SvOK(sv))
    XSRETURN_NO;
  str = SvPVbyte(sv, len);
  if (! len)
    XSRETURN_NO;
  reslt = MurmurHash1(str, len, seed);
  RETVAL = newSVuv(reslt);
OUTPUT:
  RETVAL

SV *
murmurhash3_x86_32(sv,seed)
  SV * sv
  U32 seed
PREINIT:
  char *str;
  char result[4];
  STRLEN len;
CODE:
  if (SvROK(sv))
    sv = SvRV(sv);
  if (! SvOK(sv))
    XSRETURN_NO;
  str = SvPVbyte(sv, len);
  if (! len)
    XSRETURN_NO;
  MurmurHash3_x86_32(str, len, seed, result);
  RETVAL = newSVpv(result, 4);
OUTPUT:
  RETVAL


SV *
murmurhash3_x86_128(sv,seed)
  SV* sv
  U32 seed
PREINIT:
  char *str;
  char result[16];
  STRLEN len;
CODE:
 if (SvROK(sv))
   sv = SvRV(sv);
 if (! SvOK(sv))
   XSRETURN_NO;
 str = SvPVbyte(sv, len);
 if (! len)
   XSRETURN_NO;
 MurmurHash3_x86_128(str, len, seed, result);
 RETVAL = newSVpv(result, 16);
OUTPUT:
 RETVAL


SV *
murmurhash3_x64_128(sv,seed)
  SV* sv
  U32 seed
PREINIT:
  char *str;
  char result[16];
  STRLEN len;
CODE:
  if (SvROK(sv))
    sv = SvRV(sv);
  if (! SvOK(sv))
    XSRETURN_NO;
  str = SvPVbyte(sv, len);
  if (! len)
    XSRETURN_NO;
  MurmurHash3_x64_128(str, len, seed, result);
  RETVAL = newSVpv(result, 16);
OUTPUT:
  RETVAL


