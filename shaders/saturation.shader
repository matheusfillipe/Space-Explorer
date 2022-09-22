shader_type canvas_item;

uniform float saturation = .8;
uniform float alpha = 1;
uniform vec4 alpha_color : hint_color;
uniform float alpha_threshold = .1;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    COLOR.rgb = mix(vec3(dot(tex_color.rgb, vec3(0.299, 0.587, 0.114))), tex_color.rgb, saturation);

    if(abs(tex_color.r - alpha_color.r) < alpha_threshold && abs(tex_color.g - alpha_color.g) < alpha_threshold && abs(tex_color.b - alpha_color.b) < alpha_threshold) {
        COLOR.a = 0.0;
    } else {
        COLOR.a = tex_color.a * alpha;
    }

}
