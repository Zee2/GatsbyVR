Shader "Leaves"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags{ "Queue" = "AlphaTest" "RenderType" = "TransparentCutout" "LightMode" = "Vertex"}
		LOD 100

		Pass
		{
			
			
			Tags{LightMode = Vertex}
			Cull Off
			Lighting On
			AlphaToMask On
			CGPROGRAM
			
			
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float2 uv_MainTex : TEXCOORD0;
				float3 diff : COLOR;
				UNITY_FOG_COORDS(1)
				float4 pos : POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata_full v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv_MainTex = TRANSFORM_TEX(v.texcoord, _MainTex);

				float3 viewpos = mul(UNITY_MATRIX_MV, v.vertex).xyz;

				o.diff = UNITY_LIGHTMODEL_AMBIENT.xyz;


				//All calculations are in object space
				for (int i = 0; i < 1; i++) {
					half3 toLight = unity_LightPosition[i].xyz - viewpos.xyz * unity_LightPosition[i].w;
					half lengthSq = dot(toLight, toLight);
					half atten = 1.0 / (1.0 + lengthSq * unity_LightAtten[i].z);

					fixed3 lightDirObj = mul((float3x3)UNITY_MATRIX_T_MV, toLight);	//View => model

					lightDirObj = normalize(lightDirObj);

					//fixed diff = max(0, dot(v.normal, lightDirObj));
					o.diff = 0.00;
					o.diff += unity_LightColor[i].rgb * atten;
				}

				return o;

			}

			fixed4 frag(v2f i) : SV_TARGET
			{
				// sample the texture
				fixed4 c;
				fixed4 col = tex2D(_MainTex, i.uv_MainTex);
				//clip(col.a - 0.2f);
				c.rgb = col.rgb * (i.diff*0.1);
				clip(col.a - 0.2f);
				// apply fog
				return c;
			}
		ENDCG
		}
	}
}