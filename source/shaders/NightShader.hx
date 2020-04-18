package shaders;

import flixel.system.FlxAssets.FlxShader;

class NightShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		const float scale = 1.0;

		uniform float time = 0.0;

		uniform vec3 nightColor = vec3(0,0,0);
		uniform vec3 dayColor = vec3(0,0,0);

		void main()
		{
			gl_FragColor = texture2D(bitmap, openfl_TextureCoordv);
			vec3 Ncolor = nightColor / 255.0;
			vec3 Dcolor = dayColor / 255.0;

			if (gl_FragColor.a > 0) {
				gl_FragColor.rgb = (gl_FragColor.rgb + mix(Ncolor, Dcolor, time)) * 0.5;
			}
		}')
	public function new()
	{
		super();
		this.nightColor.value = [116,117,182];
		this.dayColor.value = [229, 222, 68];
		this.time.value = [0];
	}
}