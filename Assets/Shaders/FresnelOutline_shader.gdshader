shader_type spatial;
render_mode unshaded;

uniform vec4 outline_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float fresnel_power = 1.0;
uniform float hue_speed = 0.0;

float fresnel(float amount, vec3 normal, vec3 view){
	return pow(
		1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0),
		amount
	);
}

vec3 hueShift(vec3 color, float hue) {
    const vec3 k = vec3(0.57735, 0.57735, 0.57735);
    float cosAngle = cos(hue);
    return vec3(color * cosAngle + cross(k, color) * sin(hue) + k * dot(k, color) * (1.0 - cosAngle));
}

void fragment() {
	ALBEDO = hueShift(outline_color.rgb, TIME * hue_speed);
	ALPHA = fresnel(fresnel_power, NORMAL, VIEW) * outline_color.a;
}

