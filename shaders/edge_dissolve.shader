shader_type canvas_item;

// DISSOLVE SHADER

uniform sampler2D noise_img : hint_albedo;
uniform float dissolve_value : hint_range(0,1);
uniform bool cut = true;
uniform bool combined = false;

vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float sine = sin(rotation);
    float cosine = cos(rotation);

    uv -= pivot;
    uv.x = uv.x * cosine - uv.y * sine;
    uv.y = uv.x * sine + uv.y * cosine;
    uv += pivot;

    return uv;
}

void fragment(){
    vec4 main_texture = texture(TEXTURE, UV);  // TEXTURE is texture of the sprite the shader is attached to
    vec4 noise_texture = texture(noise_img, UV);
    if (combined) {
        noise_texture.x *= texture(noise_img, rotateUV(UV, vec2(0.5), 3.141/2.0)).x;
    }
    // modify the main texture's alpha using the noise texture
    if (cut){
        main_texture.a *= floor(dissolve_value + min(0.99, noise_texture.x));
    } else {
        main_texture.a *= noise_texture.x; // floor(dissolve_value + min(0.99, noise_texture.x));
    }
    COLOR = main_texture;
}
