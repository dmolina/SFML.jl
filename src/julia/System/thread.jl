# Not currently working because of Julia threading problems
type Thread
    ptr::Ptr{CVoid}

    function Thread(ptr::Ptr{CVoid})
        t = new(ptr)
        finalizer(t, destroy)
        t
    end
end

function async_send(func::Ptr{CVoid})
    ccall(:uv_async_send, Cint, (Ptr{CVoid},), func)
    C_NULL
end

function Thread(callback::Function)
    callback_c = Base.SingleAsyncWork(data -> callback())

    # async_send(func::Ptr{CVoid}) = (ccall(:uv_async_send, Cint, (Ptr{CVoid},), func); C_NULL)
    const c_async_send = cfunction(async_send, Ptr{CVoid}, (Ptr{CVoid},))

    Thread(ccall((:sfThread_create, libcsfml_system), Ptr{CVoid}, (Ptr{CVoid}, Ptr{CVoid},), c_async_send, callback_c.handle))
end

function destroy(thread::Thread)
    ccall((:sfThread_destroy, libcsfml_system), CVoid, (Ptr{CVoid},), thread.ptr)
end

function launch(thread::Thread)
    ccall((:sfThread_launch, libcsfml_system), CVoid, (Ptr{CVoid},), thread.ptr)
end

function wait(thread::Thread)
    println("Wait")
    ccall((:sfThread_wait, libcsfml_system), CVoid, (Ptr{CVoid},), thread.ptr)
end

function terminate(thread::Thread)
    ccall((:sfThread_terminate, libcsfml_system), CVoid, (Ptr{CVoid},), thread.ptr)
end

# real_callback(data) = print(data)

# function real_callback_handle(obj::Any)
#   work = Base.SingleAsyncWork(real_callback)
#   work.handle
# end

# function callback_other_thread(handle::Ptr{CVoid})
#   ccall(:uv_async_send, Cint, (Ptr{CVoid},), handle)
# end

# const callback_other_thread_c = cfunction(callback_other_thread, Cint, (Ptr{CVoid},))
