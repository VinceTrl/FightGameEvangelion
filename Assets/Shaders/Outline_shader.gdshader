shader_type spatial;
render_mode unshaded;
varying vec4 UV_vertex;
uniform float XOpacity = 0.0;
uniform float XOffset = 9.0;
uniform float YOpacity = 0.0;
uniform float YOffset = 9.0;
uniform float ZOpacity = 0.0;
uniform float ZOffset = 9.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec4 outline_color : source_color = vec4(1.0, 0.5, 0.0, 1.0);
uniform float outline_width = 1.0;
uniform float outline_opacity = 0.5;

void vertex() {
	vec4 VERTEX_WORLD = INV_VIEW_MATRIX  * vec4(VERTEX, 1.0);
	vec4 VERTEX_LOCAL = vec4(VERTEX, 1.0);
	//UV_vertex = inverse(MODEL_MATRIX) * vec4(VERTEX, 1.0);
	UV_vertex = VERTEX_LOCAL * 100.0;
}

void fragment() {
	vec4 pixelatedtext = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec2 pixel_size = 1.0 / VIEWPORT_SIZE;
	ALBEDO =  pixelatedtext.rgb;
	
	for(int y = -1*int(outline_width); y <= 1*int(outline_width); y++)
	for(int x = -1*int(outline_width); x <= 1*int(outline_width); x++){
		vec4 tex = texture(SCREEN_TEXTURE, SCREEN_UV + vec2(float(x),float(y))*pixel_size);
		if(tex.a == 0.0 && 
		SCREEN_UV.x + float(x) * pixel_size.x < 1.0 &&
		SCREEN_UV.x + float(x) * pixel_size.x > 0.0 &&
		SCREEN_UV.y + float(y) * pixel_size.y < 1.0 &&
		SCREEN_UV.y + float(y) * pixel_size.y > 0.0){
			ALBEDO = outline_color.rgb;
			ALPHA = outline_opacity;
		}
	}
	ALBEDO = outline_color.rgb;
	ALPHA = clamp(-UV_vertex.x * 10.0 - XOffset, 0.0, 1.0) * XOpacity;
	ALPHA += clamp(-UV_vertex.y * 10.0 - YOffset, 0.0, 1.0) * YOpacity;
	ALPHA += clamp(-UV_vertex.z * 10.0 - ZOffset, 0.0, 1.0) * ZOpacity;
	
}