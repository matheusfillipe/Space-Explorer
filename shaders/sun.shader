shader_type canvas_item;

uniform sampler2D noise;

uniform float aspect_ratio: hint_range(0.0, 20.0) = 1.0;
uniform vec2 velocity = vec2(1.0, 1.0);
uniform float radius: hint_range(0.0, 1.0) = 1.0;
uniform float starting_frequency: hint_range(0.0, 3.0) = 1.0;
uniform float starting_amplitude: hint_range(0.0, 10.0) = 0.5;
uniform int octaves: hint_range(1, 20) = 4;
uniform vec4 main_color: hint_color = vec4(1.0, .8, 0.0, 1.0);
uniform vec4 second_color: hint_color = vec4(2.0, 0.0, 0.0, 1.0);
uniform vec4 third_color: hint_color = vec4(0.0, 0.0, 0.0, 1.0);


const float PI = 3.141593;

float rand(vec2 uv) {
	float amplitude = starting_amplitude;
	float frequency = starting_frequency * inversesqrt(radius);
	float output = 0.0;
	for (int i = 0; i < octaves; i++) {
		output += texture(noise, uv * frequency).x * amplitude;
		amplitude /= 2.0;
		frequency *= 2.0;
	}
    return output;
}

void fragment() {
	float x = 2.0 * (UV.x - 0.5);
	float y = 2.0 * (UV.y - 0.5);
    float px = asin(x / sqrt(radius - y * y)) * 2.0 / PI;
    float py = asin(y) * 2.0 / PI;

    vec2 uv = vec2(
        0.5 * (px + 1.0) / aspect_ratio,
        0.5 * (py + 1.0));
	vec2 motion = vec2(rand(uv + TIME * starting_frequency * velocity * sqrt(radius)));
	COLOR = mix(second_color, main_color, rand(uv + motion));
	COLOR = mix(third_color, COLOR, rand(uv + motion));
    if (x * x + y * y > radius) {
        COLOR.a = 0.0;
    }
}
