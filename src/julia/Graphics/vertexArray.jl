@enum(PrimitiveType,
points,
lines,
linesStrip,
triangles,
trianglesStrip,
triangleFan,
quads)

struct Vertex
    position::Vector2f
    color::Color
    texCoords::Vector2f
end

mutable struct VertexArray <: Drawable
    ptr::Ptr{Cvoid}

    function VertexArray(ptr::Ptr{Cvoid})
        v = new(ptr)
        finalizer(destroy, v)
        v
    end
end

function VertexArray()
    VertexArray(ccall((:sfVertexArray_create, libcsfml_graphics), Ptr{Cvoid}, ()))
end

function copy(arr::VertexArray)
    return VertexArray(ccall((:sfVertexArray_copy, libcsfml_graphics), Ptr{Cvoid}, (Ptr{Cvoid},), arr.ptr))
end

function destroy(arr::VertexArray)
    ccall((:sfVertexArray_destroy, libcsfml_graphics), Cvoid, (Ptr{Cvoid},), arr.ptr)
end

function get_vertexcount(arr::VertexArray)
    return Int(ccall((:sfVertexArray_getVertexCount, libcsfml_graphics), UInt32, (Ptr{Cvoid},), arr.ptr))
end

function get_vertex(arr::VertexArray, index::Integer)
    ptr = ccall((:sfVertexArray_getVertex, libcsfml_graphics), Ptr{Vertex}, (Ptr{Cvoid}, Csize_t,), arr.ptr, index)
    return unsafe_load(ptr)
end

function clear(arr::VertexArray)
    ccall((:sfVertexArray_clear, libcsfml_graphics), Cvoid, (Ptr{Cvoid},), arr.ptr)
end

function resize(arr::VertexArray, vertex_count::Integer)
    ccall((:sfVertexArray_resize, libcsfml_graphics), Cvoid, (Ptr{Cvoid}, UInt32,), arr.ptr, vertex_count)
end

function append(arr::VertexArray, vertex::Vertex)
    ccall((:sfVertexArray_append, libcsfml_graphics), Cvoid, (Ptr{Cvoid}, Vertex,), arr.ptr, vertex)
end

function set_primitive_type(arr::VertexArray, primitive_type::PrimitiveType)
    ccall((:sfVertexArray_setPrimitiveType, libcsfml_graphics), Cvoid, (Ptr{Cvoid}, Int32,), arr.ptr, Int32(primitive_type))
end

function get_primitive_type(arr::VertexArray)
    return PrimitiveType(ccall((:sfVertexArray_getPrimitiveType, libcsfml_graphics), Int32, (Ptr{Cvoid},), arr.ptr))
end

function getbounds(arr::VertexArray)
    return ccall((:sfVertexArray_getBounds, libcsfml_graphics), FloatRect, (Ptr{Cvoid},), arr.ptr)
end
