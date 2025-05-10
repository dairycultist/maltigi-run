shader_type spatial;
render_mode
	blend_mix,
	depth_prepass_alpha,
	shadows_disabled,
	specular_disabled,
	vertex_lighting;

uniform sampler2D albedo : source_color, filter_nearest;
uniform float uv_scale = 1.0;
uniform float alpha_cutoff : hint_range(0, 1) = 0.5;

// reference https://godotshaders.com/shader/ps1-psx-model/

void fragment() {
	
	vec4 sample = texture(albedo, UV * uv_scale);
	
	if (sample.a < alpha_cutoff) {
		discard;
	}
	
	ALBEDO = sample.rgb;
}