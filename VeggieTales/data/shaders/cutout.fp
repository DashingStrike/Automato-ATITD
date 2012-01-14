!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

TEMP texture0;
TEX texture0, fragment.texcoord[0], texture[0], 2D;
TEMP alpha;
SUB alpha.x, texture0.x, 0.5;
CMP result.color.w, alpha.x, 0, 1;
//MAD_SAT result.color.w, texture0.x, 100, -49.5;
MOV result.color.xyz, fragment.color.primary;

END
