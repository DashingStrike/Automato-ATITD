!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

PARAM param0 = program.env[0];
PARAM outlineColor = program.env[1];
PARAM glowColor = program.env[2];
PARAM glowParams = program.env[3];

TEMP texture0;
TEX texture0, fragment.texcoord[0], texture[0], 2D;

TEMP outcolor;
MOV outcolor, 0;

// Glow
TEMP t, glowCoord;
TEMP textureGlow;
ADD glowCoord, fragment.texcoord[0], glowParams;
TEX textureGlow, glowCoord, texture[0], 2D;
MAD_SAT t.w, textureGlow.w, glowParams.z, glowParams.w;
LRP outcolor, t.w, glowColor, outcolor;

// Main body
MAD_SAT t.w, texture0.w, param0.x, param0.y;
LRP outcolor, t.w, fragment.color.primary, outcolor;

MOV result.color, outcolor;

END
