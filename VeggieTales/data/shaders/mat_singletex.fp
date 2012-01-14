!!ARBfp1.0
OPTION ARB_precision_hint_fastest;

PARAM ambient = program.env[0];
PARAM light_diffuse = program.env[1];
PARAM lightdir_vs = program.env[2];
PARAM texmod0 = program.env[3];
PARAM texmod1 = program.env[4];

ATTRIB normal_vs = fragment.texcoord[1];
ATTRIB position_vs = fragment.texcoord[2];

TEMP texture0;
TEMP texcoord;
MOV texcoord.x, texmod0.z;
MOV texcoord.y, texmod0.w;
MAD texcoord.xy, fragment.texcoord[0], texmod0, texcoord;
TEX texture0, texcoord, texture[0], 2D;

TEMP temp_light_vs;
TEMP temp_light_vals;
TEMP outColor;
TEMP albedo;

MOV albedo, texture0;

	# light vector
	MOV temp_light_vs, lightdir_vs;
		# NORMALIZE(temp_light_vs)
		DP3 temp_light_vs.w, temp_light_vs, temp_light_vs;
		RSQ temp_light_vs.w, temp_light_vs.w;
		MUL temp_light_vs.xyz, temp_light_vs, temp_light_vs.w;

	# view vector
	ALIAS temp_view_vs = temp_light_vals;
	MOV temp_view_vs, -position_vs;
		# NORMALIZE(temp_view_vs)
		DP3 temp_view_vs.w, temp_view_vs, temp_view_vs;
		RSQ temp_view_vs.w, temp_view_vs.w;
		MUL temp_view_vs.xyz, temp_view_vs, temp_view_vs.w;

	# diffuse value
	DP3_SAT temp_light_vals.x, normal_vs, temp_light_vs;
	
	# somewhere near half-lambertian
	MAD temp_light_vals.x, temp_light_vals.x, 0.75, 0.25;

	# final color
	MUL temp_light_vals.xyz, temp_light_vals.x, light_diffuse;
	MAD outColor.xyz, temp_light_vals, albedo, outColor;

MUL result.color.xyz, fragment.color.primary, outColor;
MOV result.color.w, albedo.w;
#MOV result.color.rgb, fragment.texcoord[1];

END
