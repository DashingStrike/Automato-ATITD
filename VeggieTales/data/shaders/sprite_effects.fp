!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

TEMP texture2;
TEX texture2, fragment.texcoord[0], texture[2], 2D;

MOV result.color, texture2;
MUL result.color.w, fragment.color.primary.w, texture2.w;

END
