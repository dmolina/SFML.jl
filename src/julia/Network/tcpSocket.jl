mutable struct SocketTCP
    ptr::Ptr{Cvoid}

    function SocketTCP(ptr::Ptr{Cvoid})
        t = new(ptr)
        finalizer(destroy, t)
        t
    end
end

function SocketTCP()
    SocketTCP(ccall((:sfTcpSocket_create, libcsfml_network), Ptr{Cvoid}, ()))
end

function destroy(socket::SocketTCP)
    ccall((:sfTcpSocket_destroy, libcsfml_network), Cvoid, (Ptr{Cvoid},), socket.ptr)
end

function set_blocking(socket::SocketTCP, blocking::Bool)
    ccall((:sfTcpSocket_isBlocking, libcsfml_network), Cvoid, (Ptr{Cvoid}, Int32,), socket.ptr, blocking)
end

function is_blocking(socket::SocketTCP)
    return Bool(ccall((:sfTcpSocket_getBlocking, libcsfml_network), Int32, (Ptr{Cvoid},), socket.ptr))
end

function get_localport(socket::SocketTCP)
    return ccall((:sfTcpSocket_getLocalPort, libcsfml_network), UInt16, (Ptr{Cvoid},), socket.ptr)
end

function get_remoteaddress(socket::SocketTCP)
    to_string(ccall((:sfTcpSocket_getRemoteAddress, libcsfml_network), IpAddress, (Ptr{Cvoid},), socket.ptr))
end

function get_remoteport(socket::SocketTCP)
    ccall((:sfTcpSocket_getRemotePort, libcsfml_network), UInt16, (Ptr{Cvoid},), socket.ptr)
end

function connect(socket::SocketTCP, host::AbstractString, port::Integer, timeoutlen::Int64)
    timeout = Time(timeoutlen)
    host_ip = IpAddress(host)
    SocketStatus(ccall((:sfTcpSocket_connect, libcsfml_network), Int32, (Ptr{Cvoid}, IpAddress, UInt16, Time,), socket.ptr, host_ip, port, timeout))
end

function disconnect(socket::SocketTCP)
    ccall((:sfTcpSocket_disconnect, libcsfml_network), Cvoid, (Ptr{Cvoid},), socket.ptr)
end

function send(socket::SocketTCP, packet::Packet)
    SocketStatus(ccall((:sfTcpSocket_sendPacket, libcsfml_network), Int32, (Ptr{Cvoid}, Ptr{Cvoid},), socket.ptr, packet.ptr))
end

function receive(socket::SocketTCP, packet::Packet)
    nstruct = ccall((:sjTcpSocket_receivePacket, "libjuliasfml"), NetworkStruct, (Ptr{Cvoid}, Ptr{Cvoid},), socket.ptr, packet.ptr)
    packet.ptr = nstruct.ptr
    return SocketStatus(nstruct.status)
end
