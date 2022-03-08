shader_type canvas_item;

uniform bool show_mask = false;
uniform bool global = false;
uniform vec2 center;
uniform float force: hint_range(0.0, 1.0);
uniform float size: hint_range(0.0, 1.0);
uniform float thickness: hint_range(0.0, 1.0);
uniform float chroma_offset: hint_range(0.0, 0.01);


void fragment(){
    vec2 scaleUV;
    if (global) {
        float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
        scaleUV = ( SCREEN_UV - vec2(0.5, 0.0) ) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
    } else {
        scaleUV = UV;
    }
    float mask = (1.0 - smoothstep(size - thickness, size, length(scaleUV - center))) *
        smoothstep(size - thickness * 2.0, size - thickness, length(scaleUV - center));
    vec2 dir = normalize(scaleUV - center);
    vec2 disp = dir * force * mask;

    if (!show_mask) {
        // COLOR = texture(SCREEN_TEXTURE, SCREEN_UV - disp);
        COLOR.g = texture(SCREEN_TEXTURE, SCREEN_UV - disp).g;
        COLOR.r = texture(SCREEN_TEXTURE, SCREEN_UV - dir * chroma_offset * mask - disp).r;
        COLOR.b = texture(SCREEN_TEXTURE, SCREEN_UV + dir * chroma_offset * mask - disp).b;
    } else {
        COLOR.rgb = vec3(mask);
    }
}
