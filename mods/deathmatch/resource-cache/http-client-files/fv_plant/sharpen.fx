texture PixelShadTexture; 
float gPower = 1;

sampler screenSampler = sampler_state
{
 Texture = <PixelShadTexture>;
};

float4 main(float2 uv : TEXCOORD0) : COLOR0 
{ 
    float4 Color; 
	Color = tex2D( screenSampler, uv.xy);
	Color -= tex2D( screenSampler, uv.xy+0.0001)*12.0f*gPower;
	Color += tex2D( screenSampler,uv.xy-0.0001)*12.0f*gPower;
    return Color; 
};

technique PixelShad
{
 pass P1
 {
  PixelShader = compile ps_2_0 main();
 }
}