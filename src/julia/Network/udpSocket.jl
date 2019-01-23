mutable struct SocketUDP
    ptr::Ptr{Cvoid}

    function SocketUDP(ptr::Ptr{Cvoid})
        s = new(ptr)
        finalizer(destroy, s)
        s
    end
end

function SocketUDP()
    SocketUDP(ccall((:sfUdpSocket_create, libcsfml_network), Ptr{Cvoid}, ()))
end

function destroy(socket::SocketUDP)
    ccall((:sfUdpSocket_create, libcsfml_network), Cvoid, (Ptr{Cvoid},), socket.ptr)
end

function set_blocking(socket::SocketUDP, blocking::Bool)
    ccall((:sfUdpSocket_setBlocking, libcsfml_network), Cvoid, (Ptr{Cvoid}, Int32,), socket.ptr, blocking)
end

function is_blocking(socket::SocketUDP)
    Bool(ccall((:sfUdpSocket_isBlocking, libcsfml_network), Int32, (Ptr{Cvoid},), socket.ptr))
end

function get_localport(socket::SocketUDP)
    Int(ccall((:sfUdpSocket_getLocalPort, libcsfml_network), UInt16, (Ptr{Cvoid},), socket.ptr))
end

function bind(socket::SocketUDP, port::Integer)
    ccall((:sfUdpSocket_bind, libcsfml_network), Cvoid, (Ptr{Cvoid}, UInt16,), socket.ptr, port)
end

function unbind(socket::SocketUDP)
    ccall((:sfUdpSocket_unbind, libcsfml_network), Cvoid, (Ptr{Cvoid},), socket.ptr)
end

function send(socket::SocketUDP, packet::Packet, ipaddress::IpAddress, port::Integer)
    SocketStatus(ccall((:sfUdpSocket_sendPacket, libcsfml_network), Int32, (Ptr{Cvoid}, Ptr{Cvoid}, IpAddress, UInt16,), socket.ptr, packet.ptr, ipaddress, port))
end

function receive(socket::SocketUDP, packet::Packet, ipaddress::IpAddress, port::UInt16)
    ipaddress_ptr = pointer_from_objref(ipaddress)
    status = SocketStatus(ccall((:sfUdpSocket_receivePacket, libcsfml_network), Int32, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{IpAddress}, Ref{UInt16},), socket.ptr, packet.ptr, ipaddress_ptr, Ref(port)))
    status
end

function max_datagram_size()
    ccall((:sfUdpSocket_maxDatagramSize, libcsfml_network), UInt32, ())
end

