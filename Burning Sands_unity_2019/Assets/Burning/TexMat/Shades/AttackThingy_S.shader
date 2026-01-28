Shader "Custom/AttackThingy_S"
{
    Properties
    {
        _Color ("Saber Color", Color) = (1,1,1)
        _RotationRate ("Rotation Rate", Vector) = (0,0,0,0)
        _Rotation ("Rotation", Vector) = (0,0,0,0)
        _uvworldpos ("UV", Vector) = (1,1,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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
                float3 normal : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
                float3 worldPosition : TEXCOORD2;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            float3 _Rotation;
            float3 _RotationRate;
            float3 _Color;
            float3 _uvworldpos;

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                // Rotate Vertices
                _Rotation += float3(_RotationRate.x*_Time.y, _RotationRate.y*_Time.y, _RotationRate.z*_Time.y);
                v.vertex = rotatePoint(_Rotation, v.vertex.xyz).xyzz; // from Math.cginc

                // Output Rotated Vertex
                o.vertex = UnityObjectToClipPos(v.vertex);

                // Normal
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.normal = rotatePoint(_Rotation, v.normal); // from Math.cginc

                o.viewDir = WorldSpaceViewDir (v.vertex);
                o.worldPosition = localToWorld(v.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float3 lightDirection = dot(normalize (i.viewDir), -_WorldSpaceLightPos0);
                float3 color = _Color * pow(voronoi(i.worldPosition.zxy*_uvworldpos +_Time.x*10), 3);
                return float4(color + saturate(lightDirection), 0);
            }
            ENDCG
        }
        Pass
        {
            Name "ShadowCaster"
            Tags { "LightMode" = "ShadowCaster" }
            ZWrite On ZTest LEqual
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Assets/VivifyTemplate/Utilities/Shader Functions/Math.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
                float3 viewDir : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            float3 _Rotation;
            float3 _RotationRate;
            float3 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_OUTPUT(v2f, o);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

                // Rotate Vertices
                _Rotation += float3(_RotationRate.x*_Time.y, _RotationRate.y*_Time.y, _RotationRate.z*_Time.y);
                v.vertex = rotatePoint(_Rotation, v.vertex.xyz).xyzz; // from Math.cginc

                // Output Rotated Vertex
                o.vertex = UnityObjectToClipPos(v.vertex);

                // Normal
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.normal = rotatePoint(_Rotation, v.normal); // from Math.cginc

                o.viewDir = WorldSpaceViewDir (v.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            ENDCG
        }

    }
}
