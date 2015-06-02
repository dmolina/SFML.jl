type SocketUDP
	ptr::Ptr{Void}

	function SocketUDP(ptr::Ptr{Void})
		s = new(ptr)
		finalizer(s, destroy)
		s
	end
end

function SocketUDP()
	SocketUDP(ccall((:sfUdpSocket_create, "libcsfml-network"), Ptr{Void} ()))
end

function destroy(socket::SocketUDP)
	ccall((:sfUdpSocket_create, "libcsfml-network"), Void, (Ptr{Void},), socket.ptr)
end

function set_blocking(socket::SocketUDP, blocking::Bool)
	ccall((:sfUdpSocket_setBlocking, "libcsfml-network"), Void, (Ptr{Void}, Int32,), socket.ptr, blocking)
end

function is_blocking(socket::SocketUDP)
	Bool(ccall((:sfUdpSocket_isBlocking, "libcsfml-network"), Int32, (Ptr{Void},), socket.ptr))
end

function get_localport(socket::SocketUDP)
	Int(ccall((:sfUdpSocket_getLocalPort, "libcsfml-network"), Uint16, (Ptr{Void},), socket.ptr))
end

function bind(socket::SocketUDP, port::Integer)
	ccall((:sfUdpSocket_bind, "libcsfml-network"), Void, (Ptr{Void}, Uint16,), socket.ptr, port)
end

function unbind(socket::SocketUDP)
	ccall((:sfUdpSocket_unbind, "libcsfml-network"), Void, (Ptr{Void},), socket.ptr)
end

function send(socket::SocketUDP, packet::Packet, ipaddress::IpAddress, port::Integer)
	SocketStatus(ccall((:sfUdpSocket_sendPacket, "libcsfml-network"), Int32, (Ptr{Void}, Ptr{Void}, IpAddress, Uint16,), socket.ptr, packet.ptr, ipaddress, port))
end

function receive(socket::SocketUDP, packet::Packet, ipaddress::IpAddress, port::Uint16)
	ipaddress_ptr = pointer_from_objref(IpAddress)
	status = SocketStatus(ccall((:sfUdpSocket_receivePacket, "libcsfml-network"), Int32, (Ptr{Void}, Ptr{Void}, Ptr{IpAddress}, Ptr{Uint16},), socket.ptr, packet.ptr, ipaddress_ptr, port_ptr))
	status
end

function max_datagram_size()
	ccall((:sfUdpSocket_maxDatagramSize, "libcsfml-network"), Uint32, ())
end

export SocketUDP, set_blocking, is_blocking, get_localport, bind, unbind, send, receive, max_datagram_size
