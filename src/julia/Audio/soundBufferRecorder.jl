type SoundBufferRecorder
    ptr::Ptr{CVoid}

    function SoundBufferRecorder(ptr::Ptr{CVoid})
        s = new(ptr)
        # finalizer(s, destroy)
        # s
    end
end

function SoundBufferRecorder()
    SoundBufferRecorder(ccall((:sfSoundBufferRecorder_create, libcsfml_audio), Ptr{CVoid}, ()))
end

function destroy(recorder::SoundBufferRecorder)
    println("Destroy")
    ccall((:sfSoundBufferRecorder_destroy, libcsfml_audio), CVoid, (Ptr{CVoid},), recorder.ptr)
end

function start(recorder::SoundBufferRecorder, sample_rate::Integer = 44100)
    ccall((:sfSoundBufferRecorder_start, libcsfml_audio), CVoid, (Ptr{CVoid}, UInt32), recorder.ptr, sample_rate)
end

function stop(recorder::SoundBufferRecorder)
    ccall((:sfSoundBufferRecorder_stop, libcsfml_audio), CVoid, (Ptr{CVoid},), recorder.ptr)
end

function get_sample_rate(recorder::SoundBufferRecorder)
    return Int(ccall((:sfSoundBufferRecorder_getSampleRate, libcsfml_audio), UInt32, (Ptr{CVoid},), recorder.ptr))
end

function get_buffer(recorder::SoundBufferRecorder)
    return SoundBuffer(ccall((:sfSoundBufferRecorder_getBuffer, libcsfml_audio), Ptr{CVoid}, (Ptr{CVoid},), recorder.ptr))
end
