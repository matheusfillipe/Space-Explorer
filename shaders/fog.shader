shader_type canvas_item;

// glow info
uniform float hdr_threshold: hint_range(0,1) = 1.0; // Pixels with higher color than 1 will glow

// Amount of detail.
uniform int octaves = 4;

// Opacity of the output fog.
uniform float starting_amplitude: hint_range(0.0, 0.5) = 0.5;

// Rate of pattern within the fog.
uniform float starting_frequency = 1.0;

// Shift towards transparency (clamped) for sparser fog.
uniform float shift: hint_range(-1.0, 0.0) = -0.2;

// Direction and speed of travel.
uniform vec2 velocity = vec2(1.0, 1.0);

// Color of the fog.
uniform vec4 fog_color: hint_color = vec4(0.0, 0.0, 0.0, 1.0);

// Noise texture; OpenSimplexNoise is great, but any filtered texture is fine.
uniform sampler2D noise;


uniform sampler2D dissolve_noise_img : hint_albedo;
uniform float dissolve_value : hint_range(0,1);
uniform bool dissolve_cut = true;
uniform bool dissolve_rotate = false;



uniform sampler2D radial_dissolve_curve;

float rand(vec2 uv) {
	float amplitude = starting_amplitude;
	float frequency = starting_frequency;
	float output = 0.0;
	for (int i = 0; i < octaves; i++) {
		output += texture(noise, uv * frequency).x * amplitude;
		amplitude /= 2.0;
		frequency *= 2.0;
	}
	return clamp(output + shift, 0.0, 1.0);
}

vec4 sample_glow_pixel(sampler2D tex, vec2 uv) {
    return max(texture(tex, uv, 2.0) - hdr_threshold, vec4(0.0));
}

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);

    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}

vec4 dissolve(vec4 main_texture, vec2 uv) {
    vec4 noise_texture = texture(dissolve_noise_img, uv);
    if (dissolve_rotate) {
        noise_texture.x *= texture(dissolve_noise_img, rotateUV(uv, vec2(0.5), 3.141/2.0)).x;
    }
    // modify the main texture's alpha using the noise texture
    if (dissolve_cut){
        main_texture.a *= floor(dissolve_value + min(0.99, noise_texture.x));
    } else {
        main_texture.a *= noise_texture.x; // floor(dissolve_value + min(0.99, noise_texture.x));
    }
    return main_texture;
}



void fragment() {
    // fog
	vec2 motion = vec2(rand(UV + TIME * starting_frequency * velocity));
	vec4 fog = mix(vec4(0.0), fog_color, rand(UV + motion));

    // GLOW
    vec2 ps = SCREEN_PIXEL_SIZE;
    // Get blurred color from pixels considered glowing
    vec4 col0 = sample_glow_pixel(TEXTURE, UV + vec2(-ps.x, 0));
    vec4 col1 = sample_glow_pixel(TEXTURE, UV + vec2(ps.x, 0));
    vec4 col2 = sample_glow_pixel(TEXTURE, UV + vec2(0, -ps.y));
    vec4 col3 = sample_glow_pixel(TEXTURE, UV + vec2(0, ps.y));

    vec4 glowing_col = 0.25 * (col0 + col1 + col2 + col3);
    vec4 col = fog;

	vec2 vecToCenter = vec2(0.5, 0.5) - UV;
	float distToCenter = length(vecToCenter);
	float curveVal = texture(radial_dissolve_curve, vec2(distToCenter)).r;
    COLOR = dissolve(vec4(col.rgb + glowing_col.rgb, fog.a * curveVal), UV);
}
