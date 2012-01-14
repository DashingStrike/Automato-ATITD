!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

PARAM param0 = program.env[0];

TEMP texture0;
TEX texture0, fragment.texcoord[0], texture[0], 2D;
TEMP res;
MAD_SAT res.w, texture0.w, param0.x, param0.y;
MUL result.color.w, res.w, fragment.color.primary.w;
MOV result.color.xyz, fragment.color.primary;

END
