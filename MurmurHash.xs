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

// U32
// murmur_hash(char *data, size_t len) {
// return MurmurHash1(data, len, 0);
// } 

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
    reslt = MurmurHash1(str, len, 0);
    RETVAL = newSVuv(reslt);
OUTPUT:
    RETVAL

SV *
murmurhash3_x86_32(sv,seed)
	SV * sv
	int seed
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
	int seed
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
	int seed
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


