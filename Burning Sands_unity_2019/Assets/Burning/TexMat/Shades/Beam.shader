Shader "Custom/Beam"
{
    Properties
    {
        _Opacity ("Opacity", float) = 1
        _Offset ("Offset", float) = 0
    }
    SubShader
    {
        // Renders this material after opaque geometry
        Tags { "RenderType"="Transparent" "Queue"="Transparent" }
        //Blend SrcColor One
        Blend SrcColor OneMinusSrcColor

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 localPosition : TEXCOORD0;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            float _Opacity;
            float _Offset;

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.localPosition = v.vertex;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 forward = normalize(i.localPosition);
                float3 up = float3(0, 1, 0);

                float Opaci = 1-dot(forward+_Offset, up);
                Opaci = pow(Opaci, 1);

                return float4(float3(1,0,0)*_Opacity*Opaci, 0);
            }
            ENDCG
        }
    }
}
