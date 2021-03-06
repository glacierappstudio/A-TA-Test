﻿Shader "test/Plane"
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		[HDR]_MainColor("Color", Color) = (1, 1, 1, 1)
	}

		SubShader
		{
				Tags { "RenderType" = "Opaque" "Queue"="Geometry+1"}

				Pass
			{
					Stencil
					{
						Ref 2
						Comp Equal
						ZFail Replace
					}

					CGPROGRAM
						#pragma vertex vert
						#pragma fragment frag
						#pragma multi_compile_fog

						#include "UnityCG.cginc"

						struct appdata_t {
							float4 vertex : POSITION;
							float2 texcoord : TEXCOORD0;
						};

						struct v2f {
							float4 vertex : SV_POSITION;
							half2 texcoord : TEXCOORD0;
							UNITY_FOG_COORDS(1)
						};

						sampler2D _MainTex;
						float4 _MainTex_ST;
						float4 _MainColor;

						v2f vert(appdata_t v)
						{
							v2f o;
							o.vertex = UnityObjectToClipPos(v.vertex);
							o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
							UNITY_TRANSFER_FOG(o,o.vertex);
							return o;
						}

						fixed4 frag(v2f i) : SV_Target
						{
							fixed4 col = tex2D(_MainTex, i.texcoord) *_MainColor;
					/*		col *=4 ;*/
							UNITY_APPLY_FOG(i.fogCoord, col);
							UNITY_OPAQUE_ALPHA(col.a);
							return col;
						}
					ENDCG
				}
		}
}