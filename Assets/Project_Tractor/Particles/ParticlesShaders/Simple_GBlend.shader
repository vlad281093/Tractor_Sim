// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "AdvancedParticleKit/Simple (G Blend)" {
	Properties {
		_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
		_MainTex ("Main Texture", 2D) = "white" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Transparent" }
		ZWrite Off
		Cull Off
		ColorMask RGB
		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_particles
			#pragma multi_compile APK_SOFT_ON APK_SOFT_OFF

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _TintColor;
			#if SOFTPARTICLES_ON && APK_SOFT_ON
			sampler2D _CameraDepthTexture;
			float _InvFade;
			#endif

			struct appdata {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				#if SOFTPARTICLES_ON && APK_SOFT_ON
				float4 projPos : TEXCOORD2;
				#endif
			};

			v2f vert(appdata v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.color = v.color;
				#if SOFTPARTICLES_ON && APK_SOFT_ON
				o.projPos = ComputeScreenPos(o.pos);
				COMPUTE_EYEDEPTH(o.projPos.z);
				#endif
				return o;
			}

			half4 frag(v2f i) : COLOR {
				#if SOFTPARTICLES_ON && APK_SOFT_ON
				float sceneZ = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos))));
				float partZ = i.projPos.z;
				float fade = saturate(_InvFade * (sceneZ-partZ));
				i.color.a *= fade;
				#endif

				half4 texColor = tex2D(_MainTex, i.texcoord);
				half4 color = i.color * _TintColor * 2.0;
				color.a *= texColor.g;
				return color;
			}
			ENDCG
		}
	}
	FallBack "Particles/Alpha Blended"
	CustomEditor "AdvancedParticleKitSoftParticleInspector"
}
