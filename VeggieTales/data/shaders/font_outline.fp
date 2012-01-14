!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

PARAM param0 = program.env[0];
PARAM outlineColor = program.env[1];

TEMP texture0;
TEX texture0, fragment.texcoord[0], texture[0], 2D;

TEMP outcolor;
MOV outcolor, 0;

// Outline
TEMP t;
MOV outcolor.xyz, outlineColor;
MAD_SAT outcolor.w, texture0.w, param0.x, param0.z;
MUL outcolor.w, outcolor.w, outlineColor.w;
// LRP outcolor, t.w, outlineColor, outcolor; // Makes a blackish border

// Main body
MAD_SAT t.w, texture0.w, param0.x, param0.y;
LRP outcolor, t.w, fragment.color.primary, outcolor;

MOV result.color, outcolor;

END
