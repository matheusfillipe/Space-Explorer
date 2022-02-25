shader_type canvas_item;

uniform bool active = true;
uniform vec4 color : hint_color;

void fragment(){
	// Fill color
	vec4 original_color = texture(TEXTURE, UV);
	vec4 new_color = vec4(color.r, color.g, color.b, original_color.a * color.a);
	if (active)
		COLOR = new_color;
	else
		COLOR = original_color;
}
