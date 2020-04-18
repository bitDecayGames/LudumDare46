package shaders;

import flixel.system.FlxAssets.FlxShader;

class NightShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header

		uniform float time = 0.0; // from 0 to 1 being full night to full day

		uniform vec3 nightColor = vec3(0,0,0);
		uniform vec3 dayColor = vec3(0,0,0);
		uniform vec3 fireColor = vec3(0,0,0);

		uniform vec2 firePos = vec2(0,0);
		uniform float fireRadius = 0.2;

		void main()
		{
			gl_FragColor = texture2D(bitmap, openfl_TextureCoordv);

			if (gl_FragColor.a > 0) {
				vec3 timeInfluence = mix(nightColor, dayColor, time);
				float fireInfluence = fireRadius - distance(openfl_TextureCoordv, firePos);
				
				// normalize to a linear 0.0-1.0 value
				fireInfluence = clamp(fireInfluence, 0, fireRadius) / fireRadius;

				// reverse exponential decay
				fireInfluence = (1 - pow(fireInfluence - 1, 2));

				// exponential decay
				// fireInfluence = pow(fireInfluence, 2);

				// This line is for testing the raw fire influence
				// gl_FragColor.rgba = vec4(fireInfluence, fireInfluence, fireInfluence, 1);

				vec3 totalInfluence = mix(timeInfluence, fireColor, fireInfluence);

				gl_FragColor.rgb = gl_FragColor.rgb * totalInfluence;
			}
		}')
	public function new()
	{
		super();
		this.nightColor.value = [0.454,0.459,0.714];
		// this.dayColor.value = [0.898, 0.870, 0.267];
		this.dayColor.value = [1,1,1];
		this.firePos.value = [0.25, 0.5];
		this.fireColor.value = [0.929, 0.890, 0.352];
		this.fireRadius.value = [0.2];
		this.time.value = [0];
	}
}