mutable struct Clock
    ptr::Ptr{Cvoid}

    function Clock(ptr::Ptr{Cvoid})
        c = new(ptr)
        finalizer(destroy, c)
        c
    end
end

function Clock()
    Clock(ccall((:sfClock_create, libcsfml_system), Ptr{Cvoid}, ()))
end

function copy(clock::Clock)
    return Clock(ccall((:sfClock_copy, libcsfml_system), Ptr{Cvoid}, (Ptr{Cvoid},), clock.ptr))
end

function destroy(clock::Clock)
    ccall((:sfClock_destroy, libcsfml_system), Cvoid, (Ptr{Cvoid},), clock.ptr)
end

function get_elapsed_time(clock::Clock)
    return ccall((:sfClock_getElapsedTime, libcsfml_system), Time, (Ptr{Cvoid},), clock.ptr)
end

function restart(clock::Clock)
    return ccall((:sfClock_restart, libcsfml_system), Time, (Ptr{Cvoid},), clock.ptr)
end
