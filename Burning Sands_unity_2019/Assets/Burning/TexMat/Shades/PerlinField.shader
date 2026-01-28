Shader "Custom/PerlinField"
{
    Properties
    {
        _uvworldpos ("UV", Vector) = (1,1,1)
        _opacity ("Opacity", Range(0, 1)) = 1
        _opacityam ("Opacity tune", float) = 0
        _opacitypow ("Opacity power", float) = 1
        _timespeed ("Time speed", float) = 1
        _HaloInnerRadius ("Halo Inner Radius", Range(0, 1)) = 0.3
        _HaloOuterRadius ("Halo Outer Radius", Range(0, 1)) = 0.6
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        Blend SrcColor One
        Cull off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Assets/VivifyTemplate/Utilities/Shader Functions/Math.cginc"
            #include "Assets/VivifyTemplate/Utilities/Shader Functions/Noise.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 worldPosition : TEXCOORD1;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPosition = localToWorld(v.vertex);
                o.uv = v.uv;
                return o;
            }

            //https://www.shadertoy.com/view/MlVGDK

            float n ( float3 x ) {
                float s = perlin(x);
                for (float i = 2.0; i < 10.0; i += 1.0) {
                    s += perlin(x / i) / i;
                }
                return s;
            }

            float3 _uvworldpos;
            float _opacity;
            float _opacityam;
            float _opacitypow;
            float _timespeed;
            float _HaloInnerRadius;
            float _HaloOuterRadius;

            fixed4 frag (v2f i) : SV_Target
            {
                float3 v1 = (i.worldPosition.zxy*_uvworldpos) + _Time * _timespeed * 3.14;
                float3 v2 = (i.worldPosition.zxy*_uvworldpos) + _Time * _timespeed;
                float a = abs(n(float3(v1.xy, sin(_Time.y * _timespeed))) - n(float3(v2.xy, cos((_Time.y * _timespeed) + 3.0))));
                float powA = pow(a, 0.2);
                float3 fragColor = float3(0.0, 0.5 - powA * 0.5, 1.0 - powA);
                float opacityComplete = pow(saturate(fragColor.y+_opacityam), _opacitypow)*_opacity;

                float dist = distance(i.uv, float2(0.5, 0.5));
                float haloAlpha = smoothstep(_HaloOuterRadius, 0, dist)*smoothstep(0, _HaloInnerRadius, dist);
                return float4(fragColor * opacityComplete*haloAlpha, 0);
            }
            ENDCG
        }
    }
}
