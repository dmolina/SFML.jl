@enum(PrimitiveType,
points,
lines,
linesStrip,
triangles,
trianglesStrip,
triangleFan,
quads)

immutable Vertex
    position::Vector2f
    color::Color
    texCoords::Vector2f
end

type VertexArray <: Drawable
    ptr::Ptr{CVoid}

    function VertexArray(ptr::Ptr{CVoid})
        v = new(ptr)
        finalizer(v, destroy)
        v
    end
end

function VertexArray()
    VertexArray(ccall((:sfVertexArray_create, libcsfml_graphics), Ptr{CVoid}, ()))
end

function copy(arr::VertexArray)
    return VertexArray(ccall((:sfVertexArray_copy, libcsfml_graphics), Ptr{CVoid}, (Ptr{CVoid},), arr.ptr))
end

function destroy(arr::VertexArray)
    ccall((:sfVertexArray_destroy, libcsfml_graphics), CVoid, (Ptr{CVoid},), arr.ptr)
end

function get_vertexcount(arr::VertexArray)
    return Int(ccall((:sfVertexArray_getVertexCount, libcsfml_graphics), UInt32, (Ptr{CVoid},), arr.ptr))
end

function get_vertex(arr::VertexArray, index::Integer)
    ptr = ccall((:sfVertexArray_getVertex, libcsfml_graphics), Ptr{Vertex}, (Ptr{CVoid}, Csize_t,), arr.ptr, index)
    return unsafe_load(ptr)
end

function clear(arr::VertexArray)
    ccall((:sfVertexArray_clear, libcsfml_graphics), CVoid, (Ptr{CVoid},), arr.ptr)
end

function resize(arr::VertexArray, vertex_count::Integer)
    ccall((:sfVertexArray_resize, libcsfml_graphics), CVoid, (Ptr{CVoid}, UInt32,), arr.ptr, vertex_count)
end

function append(arr::VertexArray, vertex::Vertex)
    ccall((:sfVertexArray_append, libcsfml_graphics), CVoid, (Ptr{CVoid}, Vertex,), arr.ptr, vertex)
end

function set_primitive_type(arr::VertexArray, primitive_type::PrimitiveType)
    ccall((:sfVertexArray_setPrimitiveType, libcsfml_graphics), CVoid, (Ptr{CVoid}, Int32,), arr.ptr, Int32(primitive_type))
end

function get_primitive_type(arr::VertexArray)
    return PrimitiveType(ccall((:sfVertexArray_getPrimitiveType, libcsfml_graphics), Int32, (Ptr{CVoid},), arr.ptr))
end

function getbounds(arr::VertexArray)
    return ccall((:sfVertexArray_getBounds, libcsfml_graphics), FloatRect, (Ptr{CVoid},), arr.ptr)
end
