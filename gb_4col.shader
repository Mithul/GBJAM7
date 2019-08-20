shader_type canvas_item;

uniform vec4 color_1 = vec4(0.9686274509803922, 0.9058823529411765, 0.7764705882352941, 1);
uniform vec4 color_2 = vec4(0.8392156862745098, 0.5568627450980392, 0.28627450980392155, 1);
uniform vec4 color_3 = vec4(0.6509803921568628, 0.21568627450980393, 0.1450980392156863, 1);
uniform vec4 color_4 = vec4(0.2, 0.11764705882352941, 0.3137254901960784, 1);

uniform float offset = 0.5;

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