shader_type spatial;
render_mode unshaded;

uniform vec4 outline_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float fresnel_power = 1.0;

float fresnel(float amount, vec3 normal, vec3 view){
	return pow(
		1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0),
		amount
	);
}

void fragment() {
	ALBEDO = outline_color.rgb;
	ALPHA = fresnel(fresnel_power, NORMAL, VIEW) * outline_color.a;
}

