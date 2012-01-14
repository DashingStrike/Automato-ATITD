!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

TEMP texture0;
TEMP texture1;
TEX texture0, fragment.texcoord[0], texture[0], 2D;
TEX texture1, fragment.texcoord[0], texture[1], 2D;

TEMP value;
DP3 value, texture0, {0.2, 0.5, 0.3, 1.0};
MUL value, value, fragment.color.primary;
LRP result.color.xyz, texture1, value, texture0;
MUL result.color.w, texture0.w, fragment.color.primary.w;

END
