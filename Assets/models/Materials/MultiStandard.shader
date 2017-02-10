Shader "Custom/MultiStandard" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MatTex ("Material Albedo(RGB)", 2D) = "white" {}
		_MatNormal("Material Normal", 2D) = "white" {}
		
		_DetailTex("Detail Albedo (RGB)", 2D) = "transparent" {}
		
		_MatOcclusionPower("Material Occlusion Power", Range(0,1)) = 1
		_ObjOcclusion("Object (baked) Occlusion", 2D) = "white" {}
		_ObjOcclusionPower("Object Occlusion Power", Range(0,1)) = 1
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 4.0

		sampler2D _MatTex;
		sampler2D _MatNormal;
		

		sampler2D _DetailTex;

		sampler2D _ObjOcclusion;
		

		struct Input {
			float2 uv_MatTex;
			float2 uv_MatNormal;

			

			float2 uv_DetailTex;

			float2 uv_ObjOcclusion;
			
		};

		half _Glossiness;
		half _Metallic;
		
		half _ObjOcclusionPower;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MatTex, IN.uv_MatTex) * _Color;
			fixed4 detail = tex2D(_DetailTex, IN.uv_DetailTex);
			o.Albedo = lerp(c, detail, detail.a);
			//o.Albedo = c;


			

			//// Metallic and smoothness come from slider variables
			o.Normal = UnpackNormal(tex2D(_MatNormal, IN.uv_MatNormal));
			o.Metallic = _Metallic;
			o.Smoothness = _Glossiness * (1-detail.a);

			
			fixed4 objOcclusion = tex2D(_ObjOcclusion, IN.uv_ObjOcclusion);
			
			o.Alpha = objOcclusion.r;
			
			o.Occlusion = lerp(1, objOcclusion, _ObjOcclusionPower);
			//o.Albedo = tempAO;
			//o.Occlusion = lerp(1, matOcclusion, _MatOcclusionPower);
			
			//o.Occlusion = min(matOcclusion, objOcclusion);
		}
		ENDCG
	}
	FallBack "Diffuse"
}
