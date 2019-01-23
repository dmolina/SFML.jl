mutable struct Font
    ptr::Ptr{Cvoid}

    function Font(ptr::Ptr{Cvoid})
        f = new(ptr)
        finalizer(destroy, f)
        f
    end
end

function Font(filename::AbstractString)
    Font(ccall((:sfFont_createFromFile, libcsfml_graphics), Ptr{Cvoid}, (Ptr{Cchar},), filename))
end

function copy(font::Font)
    Font(ccall((:sfFont_createFromFile, libcsfml_graphics), Ptr{Cvoid}, (Ptr{Cvoid},), font.ptr))
end

function destroy(font::Font)
    ccall((:sfFont_destroy, libcsfml_graphics), Cvoid, (Ptr{Cvoid},), font.ptr)
end
