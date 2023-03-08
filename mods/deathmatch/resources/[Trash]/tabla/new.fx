#include "new2.fx"

texture gOrigTexure0 : TEXTURE0;
texture gCustomTex0 : CUSTOMTEX0;

float2 gUVPrePosition = float2( 0, 0 );
float2 gUVScale = float( 1 );                     // UV scale
float2 gUVScaleCenter = float2( 0.5, 0.5 );
float gUVRotAngle = float( 0 );                   // UV Rotation
float2 gUVRotCenter = float2( 0.5, 0.5 );
float2 gUVPosition = float2( 0, 0 );              // UV position

float3x3 getTextureTransform()
{
    return makeTextureTransform( gUVPrePosition, gUVScale, gUVScaleCenter, gUVRotAngle, gUVRotCenter, gUVPosition );
}

technique hello
{
    pass P0
    {
        // Set the texture
        Texture[0] = gCustomTex0;

        // Set the UV thingy
        TextureTransform[0] = getTextureTransform();

        // Enable UV thingy
        TextureTransformFlags[0] = Count2;
    }
}
