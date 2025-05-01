shader_type spatial;

//uniform sampler2D Depth : hint_depth_texture, repeat_disable, filter_nearest;
uniform sampler2D Noise : repeat_enable, filter_nearest;
uniform vec3 Color : source_color = vec3(1.0, 0.5, 0.0);

void vertex() {
	
	vec2 sample_pos = TIME * 0.1 + vec2(VERTEX.x, VERTEX.z) * 0.05;
	
	float sample = texture(Noise, sample_pos).r;
	
	float sample_px = texture(Noise, sample_pos + vec2( 0.05, 0)).r;
	float sample_nx = texture(Noise, sample_pos + vec2(-0.05, 0)).r;
	float sample_pz = texture(Noise, sample_pos + vec2(0,  0.05)).r;
	float sample_nz = texture(Noise, sample_pos + vec2(0, -0.05)).r;
	
	VERTEX.y += sample;
	
	NORMAL = vec3((sample_nx - sample_px) / 2.0, 1.0, (sample_nz - sample_pz) / 2.0);
}

void fragment() {
	
	ALBEDO = Color;
	// I wanna do stuff with ALPHA :(
	
	METALLIC = 0.0;
	SPECULAR = 1.0;
	ROUGHNESS = 0.0;
}
