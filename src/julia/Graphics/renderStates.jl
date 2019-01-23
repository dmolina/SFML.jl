mutable struct RenderStates
    ptr::Ptr{Cvoid}

    function RenderStates(ptr::Ptr{Cvoid})
        self = new(ptr)
        finalizer(destroy, self)
        self
    end
end

function RenderStates(blendmode::BlendMode=blend_alpha, shader::Shader=Shader(), texture::Texture=Texture())
    RenderStates(ccall((:sjRenderStates_create, "libjuliasfml"), Ptr{Cvoid}, (BlendMode, Ptr{Cvoid}, Ptr{Cvoid}), blendmode, shader.ptr, texture.ptr))
end

RenderStates(s::Shader) = RenderStates(blend_alpha, s, Texture())
RenderStates(t::Texture) = RenderStates(blend_alpha, Shader(), t)


function set_texture(states::RenderStates, texture::Texture)
    ccall((:sjRenderStates_setTexture, "libjuliasfml"), Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid}), states.ptr, texture.ptr)
end

function destroy(states::RenderStates)
    ccall((:sjRenderStates_destroy, "libjuliasfml"), Cvoid, (Ptr{Cvoid},), states.ptr)
end
