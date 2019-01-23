mutable struct Packet
    ptr::Ptr{Cvoid}

    function Packet(ptr::Ptr{Cvoid})
        p = new(ptr)
        finalizer(destroy, p)
        p
    end
end

function Packet()
    Packet(ccall((:sfPacket_create, libcsfml_network), Ptr{Cvoid}, ()))
end

function copy(packet::Packet)
    return Packet(ccall((:sfPacket_copy, libcsfml_network), Ptr{Cvoid}, (Ptr{Cvoid},), packet.ptr))
end

function destroy(packet::Packet)
    ccall((:sfPacket_destroy, libcsfml_network), Cvoid, (Ptr{Cvoid},), packet.ptr)
end

function clear(packet::Packet)
    ccall((:sfPacket_clear, libcsfml_network), Cvoid, (Ptr{Cvoid},), packet.ptr)
end

function get_data_size(packet::Packet)
    return ccall((:sfPacket_getDataSize, libcsfml_network), Int64, (Ptr{Cvoid},), packet.ptr)
end

function read_bool(packet::Packet)
    return Bool(ccall((:sfPacket_readBool, libcsfml_network), UInt8, (Ptr{Cvoid},), packet.ptr))
end

function read_string(packet::Packet)
    str = ""
    str = bytestring(ccall((:sjPacket_readString, "libjuliasfml"), Ptr{Cchar}, (Ptr{Cvoid}, Ptr{Cchar},), packet.ptr, str))
    return str
end

function read_int(packet::Packet)
    return Int(ccall((:sfPacket_readInt32, libcsfml_network), Int32, (Ptr{Cvoid},), packet.ptr))
end

function read_float(packet::Packet)
    return ccall((:sfPacket_readFloat, libcsfml_network), Cfloat, (Ptr{Cvoid},), packet.ptr)
end

function read_double(packet::Packet)
    return ccall((:sfPacket_readDouble, libcsfml_network), Cdouble, (Ptr{Cvoid},), packet.ptr)
end

function write(packet::Packet, value::Bool)
    ccall((:sfPacket_writeBool, libcsfml_network), Cvoid, (Ptr{Cvoid}, Int32,), packet.ptr, value)
end

function write(packet::Packet, val::Integer)
    ccall((:sfPacket_writeInt32, libcsfml_network), Cvoid, (Ptr{Cvoid}, Int32,), packet.ptr, val)
end

function write(packet::Packet, val::Cfloat)
    ccall((:sfPacket_writeFloat, libcsfml_network), Cvoid, (Ptr{Cvoid}, Cfloat,), packet.ptr, val)
end

function write(packet::Packet, val::Cdouble)
    ccall((:sfPacket_writeDouble, libcsfml_network), Cvoid, (Ptr{Cvoid}, Cdouble,), packet.ptr, val)
end

function write(packet::Packet, string::AbstractString)
    ccall((:sfPacket_writeString, libcsfml_network), Cvoid, (Ptr{Cvoid}, Ptr{Cchar},), packet.ptr, string)
end

