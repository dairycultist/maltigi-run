shader_type spatial;
render_mode
	blend_mix,
	cull_disabled,
	depth_prepass_alpha,
	shadows_disabled,
	specular_disabled,
	vertex_lighting;

uniform sampler2D albedo : source_color, filter_nearest;
uniform float uv_scale = 1.0;

// reference https://godotshaders.com/shader/ps1-psx-model/

void fragment() {
	
	ALBEDO = texture(albedo, UV * uv_scale).rgb;
}