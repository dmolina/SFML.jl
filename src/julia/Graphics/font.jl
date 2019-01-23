type Font
    ptr::Ptr{CVoid}

    function Font(ptr::Ptr{CVoid})
        f = new(ptr)
        finalizer(f, destroy)
        f
    end
end

function Font(filename::AbstractString)
    Font(ccall((:sfFont_createFromFile, libcsfml_graphics), Ptr{CVoid}, (Ptr{Cchar},), filename))
end

function copy(font::Font)
    Font(ccall((:sfFont_createFromFile, libcsfml_graphics), Ptr{CVoid}, (Ptr{CVoid},), font.ptr))
end

function destroy(font::Font)
    ccall((:sfFont_destroy, libcsfml_graphics), CVoid, (Ptr{CVoid},), font.ptr)
end
