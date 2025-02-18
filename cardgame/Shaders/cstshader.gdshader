shader_type canvas_item;
 
uniform vec4 target_color : source_color;
uniform vec4 replace_color : source_color; 
uniform vec4 target_color2 : source_color;
uniform vec4 replace_color2 : source_color; 
uniform vec4 target_color3 : source_color;
uniform vec4 replace_color3 : source_color; 
uniform float tolerance : hint_range(0, 1); 
 
void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
 
    float dist = distance(tex_color.rgb, target_color.rgb);
	float dist2 = distance(tex_color.rgb, target_color2.rgb);
	float dist3 = distance(tex_color.rgb, target_color3.rgb);
 
    if (dist < tolerance) {
        tex_color.rgb = replace_color.rgb;
    }
    if (dist2 < tolerance) {
        tex_color.rgb = replace_color2.rgb;
    }
    if (dist3 < tolerance) {
        tex_color.rgb = replace_color3.rgb;
    }
 
    COLOR = tex_color;
}