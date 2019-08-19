shader_type canvas_item;

uniform vec4 color_1 = vec4(0.78, 0.78, 0.26, 1);
uniform vec4 color_2 = vec4(0.49, 0.52, 0.15, 1);
uniform vec4 color_3 = vec4(0.0, 0.41, 0.0, 1);
uniform vec4 color_4 = vec4(0.01, 0.20, 0.0, 1);

uniform float offset = 0.3;

vec4 to_grayscale(vec4 pixcol){
	float average = (pixcol.r + pixcol.g + pixcol.b)/3.0;
	return vec4(average, average, average, 1);
}

vec4 to_gba(vec4 pixcol){
	vec4 newcol;
	if(pixcol.r > 0.0){
		newcol = color_4;
		if(pixcol.r > offset*0.5){
			newcol = color_3;
			if(pixcol.r > offset){
				newcol = color_2;
				if(pixcol.r > offset*1.5){
					newcol = color_1;
				}
			}
		}
	}
	return newcol;
}

void fragment(){
	vec4 pixel_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0);
	COLOR.rgb = to_gba(to_grayscale(pixel_color)).rgb;
}