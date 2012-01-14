!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

TEMP texture0;
TEX texture0, fragment.texcoord[0], texture[0], 2D;

MUL result.color, fragment.color.primary, texture0;

END
