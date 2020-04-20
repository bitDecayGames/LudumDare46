package shaders;

import flixel.system.FlxAssets.FlxShader;

class NightShader extends FlxShader {
	@:glFragmentSource('
		#pragma header

		uniform float time; // from 0 to 1 being full night to full day

		uniform vec3 nightColor;
		uniform vec3 dayColor;
		uniform vec3 fireColor;

		uniform vec2 firePos;
		uniform float fireRadius;

		uniform bool debugLoc;

		void main()
		{
			gl_FragColor = texture2D(bitmap, openfl_TextureCoordv);

			if (gl_FragColor.a > 0.0) {

				// linear day influence
				// vec3 timeInfluence = mix(nightColor, dayColor, time);

				// exponential day influence
				vec3 timeInfluence = mix(nightColor, dayColor, pow(time, 2.0));
				float fireInfluence = fireRadius - distance(openfl_TextureCoordv, firePos);
				
				// normalize to a linear 0.0-1.0 value
				fireInfluence = clamp(fireInfluence, 0.0, fireRadius) / fireRadius;

				// reverse exponential decay
				float revExpFireInfluence = (1.0 - pow(fireInfluence - 1.0, 2.0));

				// exponential decay
				float expfireInfluence = pow(fireInfluence, 2.0);

				// Weighted average
				float expInfluence = 1.0 - fireRadius;
				fireInfluence = revExpFireInfluence * (1.0-expInfluence);
				fireInfluence += expfireInfluence * expInfluence;

				// Straight average
				// fireInfluence = revExpFireInfluence + expfireInfluence;
				fireInfluence /= 2.0;

				// This line is for testing the raw fire influence
				// gl_FragColor.rgba = vec4(fireInfluence, fireInfluence, fireInfluence, 1.0);

				vec3 totalInfluence = mix(timeInfluence, fireColor, fireInfluence);

				gl_FragColor.rgb = gl_FragColor.rgb * totalInfluence;
			}

			if (debugLoc) {
				if (openfl_TextureCoordv.x > firePos.x - 0.001 && openfl_TextureCoordv.x < firePos.x + 0.001) {
					gl_FragColor.rgb = vec3(1.0,0.0,0.0);
				}
				if (openfl_TextureCoordv.y > firePos.y - 0.001 && openfl_TextureCoordv.y < firePos.y + 0.001) {
					gl_FragColor.rgb = vec3(1.0,0.0,0.0);
				}
			}
		}')

	public function new() {
		super();
		this.nightColor.value = [0.21, 0.21, 0.27];
		this.dayColor.value = [1.0, 1.0, 1.0];
		this.firePos.value = [0.25, 0.5];
		this.fireColor.value = [0.929, 0.890, 0.352];
		this.fireRadius.value = [0.2];
		this.time.value = [0.0];
		this.debugLoc.value = [false];
	}
}
