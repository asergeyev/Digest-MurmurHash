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
murmur_hash(char *data, size_t len) {
	// backward compatible stuff
	return MurmurHash1(data, len, 0);
} 

MODULE = Digest::MurmurHash	PACKAGE = Digest::MurmurHash


U32 murmur_hash(char *data, size_t length(data))

PROTOTYPES: ENABLE

SV *
murmurhash3_x86_32(sv,seed)
	SV* sv
	int seed
PREINIT:
  char *str;
  STRLEN len;
CODE:
    if (SvROK(sv))
        sv = SvRV(sv);
    if (! SvOK(sv))
        XSRETURN_NO;
    str = SvPVbyte(sv, len);
    if (! len)
        XSRETURN_NO;
    RETVAL = newSV(4);
    MurmurHash3_x86_32(str, len, seed, SvPVX(RETVAL));
    SvCUR_set(RETVAL, 4);
    SvPOK_on(RETVAL);
OUTPUT:
    RETVAL


