Shader "Custom/ZeeWater" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainNormal ("Main Normal", 2D) = "white" {}
		_MainHeight ("Main Normal Heightmap", 2D) = "white" {}
		_DetailNormal ("Detail Normal", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		_MainPower("Main Normal Power", Range(0,1)) = 0.0
		_DetailPower("Detail Normal Power", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainNormal;
		sampler2D _DetailNormal;
		sampler2D _MainHeight;

		struct Input {
			float2 uv_MainTex;
			float2 uv_MainNormal;
			float2 uv_DetailNormal;
			float2 uv_MainHeight;
		};

		half _Glossiness;
		half _Metallic;
		half _MainPower;
		half _DetailPower;
		fixed4 _Color;


		void surf(Input IN, inout SurfaceOutputStandard o) {
			//_Time.x = 0;
			// Albedo comes from a texture tinted by color
			//fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = _Color.rgb;
			// Metallic and smoothness come from slider variables
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness;
			o.Alpha = 1;
			//fixed4 magic = (1, (_SinTime.w + 1) / 2, 1, 1);
			fixed4 mainInvertedTex = tex2D(_MainNormal, 0.1 + (_Time.x/8) + IN.uv_MainNormal * 200);
			mainInvertedTex.g = 1 - mainInvertedTex.g;
			mainInvertedTex.a = 1 - mainInvertedTex.a;
			float3 mainInverted = UnpackNormal(mainInvertedTex);
			float3 mainStandard = UnpackNormal(tex2D(_MainNormal, (_Time.x/8) + IN.uv_MainNormal * 200));
			
			mainStandard.z = mainStandard.z / _MainPower;
			mainStandard = normalize(mainStandard);
			mainInverted.z = mainInverted.z / _MainPower;
			mainInverted = normalize(mainInverted);

			float3 main = lerp(mainStandard, mainInverted, (_SinTime.w + 1) / 2);
			
			

			fixed4 detailInvertedTex = tex2D(_DetailNormal, 0.1 + (_Time.x/-4) + IN.uv_DetailNormal * 1500);
			detailInvertedTex.g = 1 - detailInvertedTex.g;
			detailInvertedTex.a = 1 - detailInvertedTex.a;
			float3 detailInverted = UnpackNormal(detailInvertedTex);
			float3 detailStandard = UnpackNormal(tex2D(_DetailNormal, (_Time.x/-4) + IN.uv_DetailNormal * 1500));

			detailStandard.z = detailStandard.z / _DetailPower;
			detailStandard = normalize(detailStandard);
			detailInverted.z = detailInverted.z / _DetailPower;
			detailInverted = normalize(detailInverted);

			float3 detail = lerp(detailStandard, detailInverted, (_SinTime.w + 1) / 2);

			o.Normal = lerp(main, detail, 0.5);
			
		}
		ENDCG
	}
	FallBack "Diffuse"
}
