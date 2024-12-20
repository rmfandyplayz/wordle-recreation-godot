RSRC                    ShaderMaterial            ��������                                                  resource_local_to_scene    resource_name    code    script    shader    shader_parameter/blur           local://Shader_x8mmf #         res://Shaders/Blur.tres k         Shader          %  shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float blur: hint_range(0, 6) = .5;

void fragment(){
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV, blur);
	COLOR = vec4(color.r - 0.1, color.g - 0.1, color.b - 0.1, color.a);
}          ShaderMaterial                         @@      RSRC