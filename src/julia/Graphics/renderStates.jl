type RenderStates
    ptr::Ptr{CVoid}

    function RenderStates(ptr::Ptr{CVoid})
        self = new(ptr)
        finalizer(self, destroy)
        self
    end
end

function RenderStates(blendmode::BlendMode=blend_alpha, shader::Shader=Shader(), texture::Texture=Texture())
    RenderStates(ccall((:sjRenderStates_create, "libjuliasfml"), Ptr{CVoid}, (BlendMode, Ptr{CVoid}, Ptr{CVoid}), blendmode, shader.ptr, texture.ptr))
end

RenderStates(s::Shader) = RenderStates(blend_alpha, s, Texture())
RenderStates(t::Texture) = RenderStates(blend_alpha, Shader(), t)


function set_texture(states::RenderStates, texture::Texture)
    ccall((:sjRenderStates_setTexture, "libjuliasfml"), Ptr{CVoid}, (Ptr{CVoid}, Ptr{CVoid}), states.ptr, texture.ptr)
end

function destroy(states::RenderStates)
    ccall((:sjRenderStates_destroy, "libjuliasfml"), CVoid, (Ptr{CVoid},), states.ptr)
end
