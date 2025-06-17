shader_type spatial;
render_mode unshaded;

//SOUND INTEGRATION
global uniform sampler2D spectrum_texture; //global variable set up in Project Settings
varying float spectrum_value00;
varying float spectrum_value01;
varying float spectrum_value02;
varying float spectrum_value03;
varying float spectrum_value04;
varying float spectrum_value05;
varying float spectrum_value06;
varying float spectrum_value07;
varying float random_number;
uniform float soundIntensity = 1.0;
uniform float equalizer00 = 1.0;
uniform float equalizer01 = 1.0;
uniform float equalizer02 = 1.0;
uniform float equalizer03 = 1.0;
uniform float equalizer04 = 1.0;
uniform float equalizer05 = 1.0;
uniform float equalizer06 = 1.0;
uniform float equalizer07 = 1.0;

const float RENDER_DISTANCE = 100.0;
const float EPSILON = 0.01;

const vec3 lightPos = vec3(-0.5,0.5,-5.0);
const float lightRadius = 0.5;

uniform float height_scale = 1.0;
uniform float speed = 1.0;
uniform vec2 tiling = vec2(20.0, 20.0);
uniform vec2 offset = vec2(0.0, 0.0);
varying vec2 tex_position;
uniform sampler2D noise;
uniform sampler2D normalmap;
uniform sampler2D mask00;
uniform vec3 colorForeground = vec3(1.0);
uniform vec3 colorBackground = vec3(1.0);
uniform float DEBUG = 1.0;


float estimateDistance(vec3 p) {
    return distance(vec3(mod(p.x+0.5,1.0)-0.5,mod(p.y+0.5,1.0)-0.5,p.z > 0.0 ? mod(p.z+0.5,1.0)-0.5 : p.z), vec3(0.0, 0.0, 0.0))-0.25;
}

vec3 estimateNormal(vec3 p) {
    float d = estimateDistance(p);
    vec2 e = vec2(EPSILON, 0);

    vec3 n = d - vec3(
        estimateDistance(p-e.xyy),
        estimateDistance(p-e.yxy),
        estimateDistance(p-e.yyx));

    return normalize(n);
}

float rayMarch(vec3 origin, vec3 dir, out bool hit, out int steps) {
    float d = 0.0;
    steps = 0;
    hit = false;
    vec3 p = origin;
    while (d < RENDER_DISTANCE) {
        steps++;
        float ed = estimateDistance(p);
        if (ed > EPSILON) {
            d += ed;
            p = origin+dir*d;
        } else {
            hit = true;
            break;
        }
    }
    return d;
}

float estimateShade(vec3 pos)
{
    vec3 toLight = normalize(lightPos-pos);
    float distToLight = length(lightPos-pos);
    float d=lightRadius*0.1;
    float shade=0.0;
    while (d < RENDER_DISTANCE)
    {
        float ed = estimateDistance(pos + d*toLight);
        shade = max(0.5+(-ed)*distToLight/(2.0*lightRadius*d), shade);
        if(shade >= 1.0) break;

        d += max(ed, lightRadius*d/distToLight);
        if(d >= distToLight) break;
    }
    return clamp(shade, 0.0,1.0);
}


void vertex() {
	//vec3 nw = NODE_POSITION_WORLD;
	//random_number = nw.x * 23.489 + nw.y * 43.2123 + nw.z * 12.961;
	//random_number = fract(random_number);
	spectrum_value00 = texture(spectrum_texture, vec2(0.0,0)).r * equalizer00;
	spectrum_value01 = texture(spectrum_texture, vec2(0.1,0)).r * equalizer01;
	spectrum_value02 = texture(spectrum_texture, vec2(0.2,0)).r * equalizer02;
	spectrum_value03 = texture(spectrum_texture, vec2(0.3,0)).r * equalizer03;
	spectrum_value04 = texture(spectrum_texture, vec2(0.4,0)).r * equalizer04;
	spectrum_value05 = texture(spectrum_texture, vec2(0.5,0)).r * equalizer05;
	spectrum_value06 = texture(spectrum_texture, vec2(0.6,0)).r * equalizer06;
	spectrum_value07 = texture(spectrum_texture, vec2(0.7,0)).r * equalizer07;

	vec2 iResolution = 1.0 / 1.0/VIEWPORT_SIZE;
	iResolution = vec2(1.0, 1.0);
	// Normalized pixel coordinates (from 0 to 1)
	vec2 uv = (UV/iResolution.xy*2.-vec2(1.0,1.0)) * vec2(1.0,iResolution.y/iResolution.x);

	vec3 camPos = vec3(0.0,min(TIME*0.1 ,0.5),/*TIME-5.0 **/ (spectrum_value01)*3.0);
	vec3 rayDir = normalize(vec3(uv.xy, 1.0));

	bool didHit;
	int steps;

	// RM from cam to point
	float d = rayMarch(camPos, rayDir, didHit, steps);
	vec3 p = camPos+rayDir*d;
	//p.z += (1.0 - clamp(spectrum_value06, 0.0, 1.0)) * 50.0;
	vec3 lightDir = normalize(lightPos-p); // direction from point to light, not from light to point
	float diffuse = didHit ? clamp(dot(estimateNormal(p), lightDir), 0.0, 1.0) : 0.0;

	float b = diffuse;// - estimateShade(p);

	// Output to screen
	float height01 = b;

	tex_position = (vec2(VERTEX.z / tiling.x, -VERTEX.x / tiling.y)  + 0.5) ;
	float height02 = (texture(noise, vec2(tex_position.x + TIME * 0.1 * speed + spectrum_value04 * 1.0, tex_position.y + TIME * 5.0 * speed + spectrum_value06 * 3.0)).r + texture(noise, vec2(tex_position.x - TIME * 0.1 * speed + spectrum_value04 * 3.0, tex_position.y - TIME * 1.0 * speed + spectrum_value06 * 3.0)).r) / 2.0;
	float height = (height01 + spectrum_value04 * height02 * 5.0) + (height02 * 2.0 + spectrum_value03 * height02 * 5.0);
	//VERTEX.y += height * height_scale * (spectrum_value05 + 0.7);
	VERTEX.y += height * height_scale;// * height;
}

void fragment() {
	vec2 iResolution = 1.0 / 1.0/VIEWPORT_SIZE;
	iResolution = vec2(1.0, 1.0);
	// Normalized pixel coordinates (from 0 to 1)
	vec2 uv = (UV/iResolution.xy*2.-vec2(1.0,1.0)) * vec2(1.0,iResolution.y/iResolution.x);

	vec3 camPos = vec3(0.0,min(TIME*0.1,0.5),TIME-5.0);
	vec3 rayDir = normalize(vec3(uv.xy, 1.0));

	bool didHit;
	int steps;

	// RM from cam to point
	float d = rayMarch(camPos, rayDir, didHit, steps);
	vec3 p = camPos+rayDir*d;
	vec3 lightDir = normalize(lightPos-p); // direction from point to light, not from light to point
	float diffuse = didHit ? clamp(dot(estimateNormal(p), lightDir), 0.0, 1.0) : 0.0;

	float b = diffuse;// - estimateShade(p);

	vec2 UV00 = (vec2(UV.x / tiling.x, UV.y / tiling.y)) * 20.0 ;
	float height02 = (texture(noise, vec2(UV00.y + TIME * 1.0 * speed, UV00.x + TIME * 20.0 * speed)).r + texture(noise, vec2(UV00.y - TIME * 1.5 * speed, UV00.x - TIME * 20.0 * speed)).r) / 2.0;

	//vec2 UV01 = vec2(-1.0, 1.0) * vec2(tex_position.y + 0.0 + TIME * 0.1 * speed + spectrum_value03 * 0.3, tex_position.x + TIME * 5.0 * speed + spectrum_value05 * 1.0);
	//vec2 UV02 = vec2(1.0, 1.0) * vec2(tex_position.y + 0.0 - TIME * 0.1 * speed + spectrum_value04 * 1.0, tex_position.x - TIME * 1.0 * speed + spectrum_value06 * 1.0);
	vec2 UV01 = vec2(UV.x + spectrum_value01 * 0.05 * sin(TIME*3.0*spectrum_value01), UV.y + spectrum_value03 * 0.1 * sin(TIME*3.0*spectrum_value03)) + offset;
	vec2 UV02 = vec2(UV.x + spectrum_value02 * 0.1 * sin(TIME*3.0*spectrum_value02), UV.y + spectrum_value00 * 0.1 * sin(TIME*3.0*spectrum_value00)) + offset;

	//TESTER DE WARPER LES UVS
	//________________________

	METALLIC = 1.0;
	ROUGHNESS = 1.0;
	// Output to screen
	ALBEDO = vec3(b,b,b) * 0.01;
	ALBEDO += texture(noise, vec2(UV.x, UV.y) + offset).xyz;
	EMISSION = texture(noise, vec2(UV.x, UV.y) + offset).xyz * 1.0;
	ALBEDO += ((texture(noise, UV01).rgb * (spectrum_value01+spectrum_value05) * 5.0 + texture(noise, UV02).rgb) * (spectrum_value05+spectrum_value01) * 5.0) * texture(noise, UV01).rgb * texture(noise, UV02).rgb * 1.0;
	//ALBEDO += (texture(noise, vec2(UV.x, UV.y)).xyz * 1.0-texture(mask00, vec2(UV.x, UV.y)).x) * 2.0;
	//ALBEDO *= texture(mask00, vec2(UV.x, UV.y)).x;

	EMISSION = vec3(pow(EMISSION.r, 1.0), pow(EMISSION.g, 1.0), pow(EMISSION.b, 1.0));
	
	//ALBEDO = pow(ALBEDO, vec3(2.0, 2.0, 2.0));
	//FOG = vec4(0.4, 1.0, 0.7, 0.2) * ((UV.y*5.0)-0.5);
	//ALBEDO = vec3(0.0, 0.0, 0.0);
	//ALBEDO += vec3(height02)*0.2;
	//ALBEDO += vec3(0.5 * spectrum_value05 * soundIntensity, 0.0, 0.0) * 1.0;
	//ALBEDO = mix(vec3(-0.5, -0.5, -0.5),vec3(1.0, 1.0, 1.0),ALBEDO); //REMAP
	//ALBEDO = vec3(random_number);
}