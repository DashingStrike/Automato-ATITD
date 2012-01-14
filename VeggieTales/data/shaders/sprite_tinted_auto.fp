!!ARBfp1.0
OPTION ARB_precision_hint_nicest;

// syntax: CMP out, cmp, lt0, gte0

TEMP texture0;
TEX texture0, fragment.texcoord[0], texture[0], 2D;

TEMP minv, maxv;

// Calculate S and V of original image
TEMP colorvalue;
MOV colorvalue, texture0;
TEMP V;
MIN minv.r, colorvalue.r, colorvalue.g;
MIN minv.r, minv.r, colorvalue.b;
MAX maxv.r, colorvalue.r, colorvalue.g;
MAX maxv.r, maxv.r, colorvalue.b;
//ADD V.r, maxv.r, minv.r;
//MUL V.r, V.r, 0.5;
MOV V.r, maxv.r;

TEMP S;
TEMP delta; // .g is inverse
SUB delta.r, maxv.r, minv.r;
CMP maxv.g, -maxv.g, maxv.g, 1; // Replace value with 1 to avoid divide by zero
RCP maxv.g, maxv.g;
MUL S.r, delta.r, maxv.g;

//	if( delta != 0 ) // max == 0 -> delta == 0
//		*s = delta / max;		// s
//	else {
//		// r = g = b = 0		// s = 0, v is undefined
//		*s = 0;
//		*h = -1;
//		return;
//	}
CMP S.r, -delta.r, S.r, 0;





// Calculate Hue of incoming color
MOV colorvalue, fragment.color.primary;

MIN minv.r, colorvalue.r, colorvalue.g;
MIN minv.r, minv.r, colorvalue.b;
MAX maxv.r, colorvalue.r, colorvalue.g;
MAX maxv.r, maxv.r, colorvalue.b;

// Calculate delta and inverse delta
SUB delta.r, maxv.r, minv.r;
// Inverse delta
CMP delta.g, -delta.r, delta.r, 1; // Replace valud with 1 to avoid divide by zero
RCP delta.g, delta.g;

TEMP debug;

TEMP H;
MOV H.r, -1;

// Ifs in reverse order
//	else
//		*h = 4 + ( r - g ) / delta;	// between magenta & cyan
SUB H.b, colorvalue.r, colorvalue.g;
MAD H.b, H.b, delta.g, 4;
MOV H.r, H.b;
//	else if( g == max )
//		*h = 2 + ( b - r ) / delta;	// between cyan & yellow
SUB H.b, colorvalue.b, colorvalue.r;
MAD H.b, H.b, delta.g, 2;
SUB H.g, colorvalue.g, maxv.r;
CMP H.r, H.g, H.r, H.b;
//	if( r == max )
//		*h = ( g - b ) / delta;		// between yellow & magenta
SUB H.b, colorvalue.g, colorvalue.b;
MUL H.b, H.b, delta.g;
SUB H.g, colorvalue.r, maxv.r;
CMP H.r, H.g, H.r, H.b;

//	if( *h < 0 )
//		*h += 360;
CMP H.g, H.r, 6, 0;
ADD H.r, H.r, H.g;
MOV H.g, H.r;

// if (delta == 0) hue = 0
CMP H.r, -delta.r, H.r, 0;

// MUL debug.r, H.r, 0.16666666;
// MUL debug.r, S.r, 1;
// MUL debug.r, V.r, 1;

// Caluclate output RGB from the new HSV

TEMP f, p, q, t;
//	i = (int)floor( h );
//	f = h - i;			// factorial part of h
FRC f.r, H.r;
//	p = v * ( 1 - s );
SUB p.r, 1, S.r;
MUL p.r, p.r, V.r;
//	q = v * ( 1 - s * f );
// AUTO COLOR TINTING BREAKS HERE ON NEW CARDS/DRIVERS
//  result of this MAD is not what it should be
MAD_SAT q.r, S.r, -f.r, 1;
MUL q.r, V.r, q.r;
//	t = v * ( 1 - s * ( 1 - f ) );
SUB t.r, 1, f.r;
MAD t.r, -S.r, t.r, 1;
MUL t.r, V.r, t.r;


//	switch( i ) {
//		case 0:
//			*r = v;
//			*g = t;
//			*b = p;
//			break;
MOV colorvalue.r, V.r;
MOV colorvalue.g, t.r;
MOV colorvalue.b, p.r;

//		case 1:
//			*r = q;
//			*g = v;
//			*b = p;
//			break;
TEMP thiscase;
MOV thiscase.r, q.r;
MOV thiscase.g, V.r;
MOV thiscase.b, p.r;
SUB H.g, H.r, 1;
CMP colorvalue, H.g, colorvalue, thiscase;
//		case 2:
//			*r = p;
//			*g = v;
//			*b = t;
//			break;
MOV thiscase.r, p.r;
MOV thiscase.b, t.r;
SUB H.g, H.g, 1;
CMP colorvalue, H.g, colorvalue, thiscase;
//		case 3:
//			*r = p;
//			*g = q;
//			*b = v;
//			break;
MOV thiscase.g, q.r;
MOV thiscase.b, V.r;
SUB H.g, H.g, 1;
CMP colorvalue, H.g, colorvalue, thiscase;
//		case 4:
//			*r = t;
//			*g = p;
//			*b = v;
//			break;
MOV thiscase.r, t.r;
MOV thiscase.g, p.r;
SUB H.g, H.g, 1;
CMP colorvalue, H.g, colorvalue, thiscase;
//		default:		// case 5:
//			*r = v;
//			*g = p;
//			*b = q;
//			break;
//	}
MOV thiscase.r, V.r;
MOV thiscase.b, q.r;
SUB H.g, H.g, 1;
CMP colorvalue, H.g, colorvalue, thiscase;

//	if( s == 0 ) {
//		// achromatic (grey)
//		*r = *g = *b = v;
//		return;
//	}
CMP colorvalue.rgb, -S.r, colorvalue, V.r;

MOV result.color.xyz, colorvalue;
MUL result.color.w, texture0.w, fragment.color.primary.w;

// MOV result.color.xyz, debug;

END
