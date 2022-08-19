--by PbmnLuv, based on the basic shader for g3d, by Groverburger
--MIT License

local shader = love.graphics.newShader [[
    uniform mat4 projectionMatrix;
    uniform mat4 modelMatrix;
    uniform mat4 viewMatrix;
    uniform mat4 modelMatrixInverse;
    uniform vec3 l_dir = vec3(1, 1,  1);
    uniform vec3 camPos;
    uniform vec3 modelScale;
    uniform vec3 pScale;
    uniform float camHeading;
    
    
    varying vec3 normal;
    
    varying float faceHeading;
    varying float newCamHeading;
    varying float mod;
    
    varying float dist;
    
    varying vec4 vertexColor;

    #ifdef VERTEX
      attribute vec4 VertexNormal;
        vec4 position(mat4 transform_projection, vec4 vertex_position)
        {
            //possibility of making floor appear as you go
            //
            
            
            normal = vec3(vec4(modelMatrixInverse*VertexNormal));
            
            mod = sqrt(sin(normal[0])*sin(normal[0]) + cos(normal[1])*cos(normal[1]));
            faceHeading = atan(-sin(normal[0])/mod,cos(normal[1])/mod);
            faceHeading = -faceHeading;
            newCamHeading = camHeading;
            
             if (newCamHeading < 0.0f) {
              newCamHeading = newCamHeading + 3.14159265;
            }
            if (faceHeading < 0.0f) {
              faceHeading = faceHeading + 3.14159265;
            }
            
            vertexColor = VertexColor;
            return projectionMatrix * viewMatrix * modelMatrix * vertex_position;
        }
    #endif

    #ifdef PIXEL
        vec4 effect(vec4 color, Image tex, vec2 texcoord, vec2 pixcoord)
        {
        
            float intensity = 10.0f; //5.0f
            
            vec4 texcolor = Texel(tex, vec2(texcoord.x, 1-texcoord.y));
            if (texcolor.a == 0.0) { discard; }
            
            float pi = 3.14159265;
            float mult = ((normal[2]+1)/2)*((normal[2]+1)/2)*intensity;
            
            
            float a = (faceHeading-newCamHeading + pi);
            float b = (2*pi);
            float result_mod = a - (b * floor(a/b));
            
            float angle = result_mod - pi;
            
            
            float vertex_lit_mult = (abs(angle))/(3.14159265);
            
            if (vertex_lit_mult < 0.2f) {
              vertex_lit_mult = 0.2f;
            }
            
            mult = mult * vertex_lit_mult;
            
            if (mult > 1.0f || normal[2]>=0.99f){
              mult = 1.0f;
            }
            
            
            vec4 newColor = vec4(texcolor)*color*vertexColor*mult;
            newColor[3] = 1.0f;
            return newColor;
        }
    #endif
]]

return shader
