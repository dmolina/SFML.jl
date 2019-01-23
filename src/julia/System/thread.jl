# Not currently working because of Julia threading problems
mutable struct Thread
    ptr::Ptr{Cvoid}

    function Thread(ptr::Ptr{Cvoid})
        t = new(ptr)
        finalizer(destroy, t)
        t
    end
end

function async_send(func::Ptr{Cvoid})
    ccall(:uv_async_send, Cint, (Ptr{Cvoid},), func)
    C_NULL
end

function Thread(callback::Function)
    callback_c = Base.SingleAsyncWork(data -> callback())

    # async_send(func::Ptr{Cvoid}) = (ccall(:uv_async_send, Cint, (Ptr{Cvoid},), func); C_NULL)
    c_async_send = cfunction(async_send, Ptr{Cvoid}, (Ptr{Cvoid},))

    Thread(ccall((:sfThread_create, libcsfml_system), Ptr{Cvoid}, (Ptr{Cvoid}, Ptr{Cvoid},), c_async_send, callback_c.handle))
end

function destroy(thread::Thread)
    ccall((:sfThread_destroy, libcsfml_system), Cvoid, (Ptr{Cvoid},), thread.ptr)
end

function launch(thread::Thread)
    ccall((:sfThread_launch, libcsfml_system), Cvoid, (Ptr{Cvoid},), thread.ptr)
end

function wait(thread::Thread)
    println("Wait")
    ccall((:sfThread_wait, libcsfml_system), Cvoid, (Ptr{Cvoid},), thread.ptr)
end

function terminate(thread::Thread)
    ccall((:sfThread_terminate, libcsfml_system), Cvoid, (Ptr{Cvoid},), thread.ptr)
end

# real_callback(data) = print(data)

# function real_callback_handle(obj::Any)
#   work = Base.SingleAsyncWork(real_callback)
#   work.handle
# end

# function callback_other_thread(handle::Ptr{Cvoid})
#   ccall(:uv_async_send, Cint, (Ptr{Cvoid},), handle)
# end

# const callback_other_thread_c = cfunction(callback_other_thread, Cint, (Ptr{Cvoid},))
