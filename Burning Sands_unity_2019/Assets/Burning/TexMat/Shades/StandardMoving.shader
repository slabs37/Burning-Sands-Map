Shader "Custom/StandardMoving"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Tint Color", Color) = (1,1,1,1)
        _Tiling ("Tiling", Vector) = (1,1,0,0)
        _Offset ("Offset", Vector) = (0,0,0,0)
        _ScrollSpeed ("Scroll Speed (XY)", Vector) = (0,0,0,0)
        _Cutoff ("Alpha Cutoff", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        Pass
        {
            //Blend SrcAlpha OneMinusSrcAlpha
            
            Cull Back

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Color;
            float4 _Tiling;
            float4 _Offset;
            float4 _ScrollSpeed;
            fixed _Cutoff;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // Apply tiling and offset from properties
                float2 uv = v.uv * _Tiling.xy + _Offset.xy;
                // Add time-based scrolling
                uv += _ScrollSpeed.xy * _Time.y;
                o.uv = uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;
                
                // Alpha cutoff for transparency
                clip(col.a - _Cutoff);
                
                return float4(col.xyz, 0);
            }
            ENDCG
        }
    }
}