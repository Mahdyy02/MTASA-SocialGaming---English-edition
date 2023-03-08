// paint fix and reflection by Ren712
// car_refgene.fx
// 
//
// Badly converted from:
//
//      ShaderX2 � Shader Programming Tips and Tricks with DirectX 9
//      http://developer.amd.com/media/gpu_assets/ShaderX2_LayeredCarPaintShader.pdf
//
//      Chris Oat           Natalya Tatarchuk       John Isidoro
//      ATI Research        ATI Research            ATI Research
//

//some additional variables for the reflection
//for reflection factor look for brightnessFactor in piel shader

float sSparkleSize = 0.5;
float bumpSize = 1;

float2 uvMul = float2(1,1);
float2 uvMov = float2(0,0.25);

float minZviewAngleFade = -0.6;
float brightnessFactor = 0.20;
float sNormZ = 3;
float sAdd = 0.1;  
float sMul = 1.1; 
float sCutoff : CUTOFF = 0.16;         // 0 - 1
float sPower : POWER  = 2;            // 1 - 5
float sNorFac= 1;
float gShatt = false;

float3 sSkyColorTop = float3(0,0,0);
float3 sSkyColorBott = float3(0,0,0);
float sSkyLightIntensity = 0;
//---------------------------------------------------------------------
// Car paint settings
//---------------------------------------------------------------------
texture sReflectionTexture;
texture sRandomTexture;

//---------------------------------------------------------------------
// Include some common stuff
//---------------------------------------------------------------------
#include "mta-helper.fx"

//------------------------------------------------------------------------------------------
// Samplers for the textures
//------------------------------------------------------------------------------------------
sampler Sampler0 = sampler_state
{
    Texture         = (gTexture0);
    MinFilter       = Linear;
    MagFilter       = Linear;
    MipFilter       = Linear;
};

sampler3D RandomSampler = sampler_state
{
    Texture = (sRandomTexture); 
    MAGFILTER = LINEAR;
    MINFILTER = LINEAR;
    MIPFILTER = POINT;
    MIPMAPLODBIAS = 0.000000;
};

sampler2D ReflectionSampler = sampler_state
{
    Texture = (sReflectionTexture);	
    AddressU = Mirror;
    AddressV = Mirror;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
};

//---------------------------------------------------------------------
// Structure of data sent to the vertex shader
//---------------------------------------------------------------------
struct VSInput
{
    float4 Position : POSITION; 
    float3 Normal : NORMAL0;
    float4 Diffuse : COLOR0;
    float2 TexCoord : TEXCOORD0;
    float3 View : TEXCOORD1;
};

//---------------------------------------------------------------------
// Structure of data sent to the pixel shader ( from the vertex shader )
//---------------------------------------------------------------------
struct PSInput
{
    float4 Position : POSITION;
    float4 Diffuse : COLOR0;
    float4 Specular : COLOR1;   
    float2 TexCoord : TEXCOORD0;
    float3 Tangent : TEXCOORD1;
    float3 Binormal : TEXCOORD2;
    float3 Normal : TEXCOORD3;
    float3 View : TEXCOORD4;
    float3 SparkleTex : TEXCOORD5;
    float3 NormalCl : TEXCOORD6;
    float NormalZ : TEXCOORD7;
};


//------------------------------------------------------------------------------------------
// VertexShaderFunction
//  1. Read from VS structure
//  2. Process
//  3. Write to PS structure
//------------------------------------------------------------------------------------------
PSInput VertexShaderFunction(VSInput VS)
{
    PSInput PS = (PSInput)0;
	
    float4 worldPosition = mul ( VS.Position, gWorld );
    float4 viewPosition  = mul ( worldPosition, gView );
    PS.Position  = mul ( viewPosition, gProjection );
 
    PS.View = gCameraPosition - worldPosition;
	
    // Fake tangent and binormal
    float3 Tangent = VS.Normal.yxz;
    Tangent.xz = VS.TexCoord.xy;
    float3 Binormal = normalize( cross(Tangent, VS.Normal) );
    Tangent = normalize( cross(Binormal, VS.Normal) );

    // Transfer some stuff
    PS.Tangent = normalize(mul(Tangent, gWorldInverseTranspose).xyz);
    PS.Binormal = normalize(mul(Binormal, gWorldInverseTranspose).xyz);
    PS.Normal = normalize( mul(VS.Normal, (float3x3)gWorld) );

    PS.SparkleTex.x = fmod( VS.Position.x, 10 ) * 4.0/sSparkleSize;
    PS.SparkleTex.y = fmod( VS.Position.y, 10 ) * 4.0/sSparkleSize;
    PS.SparkleTex.z = fmod( VS.Position.z, 10 ) * 4.0/sSparkleSize; 

    float3 ViewNormal = normalize( mul(VS.Normal, (float3x3)gWorldView) );	
    float4 posNorm = float4(VS.Position.xyz,1);
    posNorm.xyz += float3(ViewNormal.xy * sNorFac * 0.25, ViewNormal.z * sNorFac);

    float4 pPos = mul(posNorm, gWorldViewProjection); 
    float projectedX = (0.5 * (pPos.x/pPos.w)) * uvMul.x + 0.5 + uvMov.x;
    float projectedY = (0.5 * (pPos.y/pPos.w)) * uvMul.y + 0.5 + uvMov.y;
    float2 TexCoord = float2(projectedX,projectedY);

    // send reflection lookup coords to pixel shader
    PS.TexCoord = float2(TexCoord.x, TexCoord.y);	

    // Calc lighting
    PS.Diffuse = MTACalcGTAVehicleDiffuse( PS.Normal, VS.Diffuse );
    // Normal Z vector for sky light 
    float worldNormalZ = mul(VS.Normal,(float3x3)gWorld).z;
    float skyTopmask = pow(worldNormalZ,5);
    PS.Specular.rgb = (skyTopmask * sSkyColorTop + saturate(worldNormalZ-skyTopmask)* sSkyColorBott );
    PS.Specular.rgb *= gGlobalAmbient.xyz;
    PS.Specular.a = pow(worldNormalZ,sNormZ);
    PS.NormalZ = PS.Specular.a;
    if (gCameraDirection.z < minZviewAngleFade) 
	{ PS.Specular.a = PS.NormalZ * saturate(( 1 /(1 + minZviewAngleFade))*(1 + gCameraDirection.z)); 
      PS.Specular.a = pow(PS.Specular.a,3);
	}
	
    return PS;
}


//------------------------------------------------------------------------------------------
// PixelShaderFunction
//  1. Read from PS structure
//  2. Process
//  3. Return pixel color
//------------------------------------------------------------------------------------------
float4 PixelShaderFunction(PSInput PS) : COLOR0
{
    // Some settings for something or another
    float microflakePerturbation = 1.00;
    float normalPerturbation = 1.00;
    float microflakePerturbationA = 0.10;

    // Get the surface normal
    float3 vNormal = PS.Normal;

    // Micro-flakes normal map is a high frequency normalized
    // vector noise map which is repeated across the surface.
    // Fetching the value from it for each pixel allows us to
    // compute perturbed normal for the surface to simulate
    // appearance of micro-flakes suspended in the coat of paint:
    float3 vFlakesNormal = tex3D(RandomSampler, PS.SparkleTex).rgb;

    // Don't forget to bias and scale to shift color into [-1.0, 1.0] range:
    vFlakesNormal = 2 * vFlakesNormal - 1.0;

    // This shader simulates two layers of micro-flakes suspended in
    // the coat of paint. To compute the surface normal for the first layer,
    // the following formula is used:
    // Np1 = ( a * Np + b * N ) / || a * Np + b * N || where a << b
    //
    float3 vNp1 = microflakePerturbationA * vFlakesNormal + normalPerturbation * vNormal ;

    // To compute the surface normal for the second layer of micro-flakes, which
    // is shifted with respect to the first layer of micro-flakes, we use this formula:
    // Np2 = ( c * Np + d * N ) / || c * Np + d * N || where c == d
    float3 vNp2 = microflakePerturbation * (( vFlakesNormal + 1.0)/2) ;

    // The view vector (which is currently in world space) needs to be normalized.
    // This vector is normalized in the pixel shader to ensure higher precision of
    // the resulting view vector. For this highly detailed visual effect normalizing
    // the view vector in the vertex shader and simply interpolating it is insufficient
    // and produces artifacts.

    float3 vView = normalize(PS.View);
    // Transform the surface normal into world space (in order to compute reflection
    // vector to perform environment map look-up):
    float3x3 mTangentToWorld = transpose( float3x3( PS.Tangent,PS.Binormal, PS.Normal ) );
    float3 vNormalWorld = normalize( mul( mTangentToWorld, vNormal ));
       
    // Compute reflection vector resulted from the clear coat of paint on the metallic
    // surface:
	
    float fNdotV = saturate(dot( vNormalWorld, vView ));

    // Reflection lookup coords to pixel shader
    float2 vReflection = float2(PS.TexCoord.x,PS.TexCoord.y);
	
    // Hack in some bumpyness
    vReflection.x += vNp2.x * (0.1 * bumpSize) - (0.1 * bumpSize);
    vReflection.y += vNp2.y * (0.05 * bumpSize) - (0.05 * bumpSize);
	
    float4 envMap = tex2D( ReflectionSampler, vReflection );
    float lum = (envMap.r + envMap.g + envMap.b)/3;
    float adj = saturate( lum - sCutoff );
    adj = adj / (1.01 - sCutoff);
    envMap += sAdd+1.0; 
    envMap = (envMap * adj);
    envMap = pow(envMap, sPower+2); 
    envMap *= sMul;

    // Brighten the environment map sampling result:
    envMap.rgb *= brightnessFactor;	
	
    envMap.a =1;	
    float4 first = float4((envMap.rgb+ 0.5 * PS.Specular.rgb * sSkyLightIntensity),PS.Specular.a);
    float4 second = float4(1.1 * (PS.Specular.rgb),1.1 * sSkyLightIntensity * PS.NormalZ);

    envMap = lerp(first,second,1-PS.Specular.a);
	
    float4 Color = envMap;
    Color.a *=PS.NormalZ;

    if (!gShatt) {
        if (PS.Diffuse.a >=0.8) {Color.rgba=0;}  
            }
            else
            {
        Color.a *= 0.65;
			}
    Color.a *= PS.Diffuse.a;
    return Color;
}

//------------------------------------------------------------------------------------------
// Techniques
//------------------------------------------------------------------------------------------
technique car_reflect_generic_v2
{
    pass P0
    {
        DepthBias = -0.0003;
        AlphaRef = 1;
        AlphaBlendEnable = TRUE;
        VertexShader = compile vs_2_0 VertexShaderFunction();
        PixelShader  = compile ps_2_0 PixelShaderFunction();
    }
}

// Fallback
technique fallback
{
    pass P0
    {
        // Just draw normally
    }
}
