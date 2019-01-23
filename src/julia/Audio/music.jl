mutable struct Music
    ptr::Ptr{Cvoid}

    function Music(ptr::Ptr{Cvoid})
        m = new(ptr)
        finalizer(destroy, m)
        m
    end
end

function Music(filename::AbstractString)
    Music(ccall((:sfMusic_createFromFile, libcsfml_audio), Ptr{Cvoid}, (Ptr{Cchar},), filename))
end

function destroy(music::Music)
    ccall((:sfMusic_destroy, libcsfml_audio), Cvoid, (Ptr{Cvoid},), music.ptr)
end

function set_loop(music::Music, loop::Bool)
    ccall((:sfMusic_setLoop, libcsfml_audio), Cvoid, (Ptr{Cvoid}, Int32,), music.ptr, loop)
end

function get_loop(music::Music)
    return Bool(ccall((:sfMusic_getLoop, libcsfml_audio), Int32, (Ptr{Cvoid},), music.ptr))
end

function play(music::Music)
    ccall((:sfMusic_play, libcsfml_audio), Cvoid, (Ptr{Cvoid},), music.ptr)
end

function pause(music::Music)
    ccall((:sfMusic_pause, libcsfml_audio), Cvoid, (Ptr{Cvoid},), music.ptr)
end

function stop(music::Music)
    ccall((:sfMusic_pause, libcsfml_audio), Cvoid, (Ptr{Cvoid},), music.ptr)
end

function get_duration(music::Music)
    return ccall((:sfMusic_getDuration, libcsfml_audio), Time, (Ptr{Cvoid},), music.ptr)
end

function get_channelcount(music::Music)
    return Real(ccall((:sfMusic_getChannelCount, libcsfml_audio), UInt32, (Ptr{Cvoid},), music.ptr))
end

function get_samplerate(music::Music)
    return Real(ccall((:sfMusic_getSampleRate, libcsfml_audio), UInt32, (Ptr{Cvoid},), music.ptr))
end

function set_pitch(music::Music, pitch::Real)
    ccall((:sfMusic_setPitch, libcsfml_audio), Cvoid, (Ptr{Cvoid}, Cfloat,), music.ptr, pitch)
end

function set_volume(music::Music, volume::Real)
    ccall((:sfMusic_setVolume, libcsfml_audio), Cvoid, (Ptr{Cvoid}, Cfloat,), music.ptr, volume)
end

function get_pitch(music::Music)
    return Real(ccall((:sfMusic_getPitch, libcsfml_audio), Cfloat, (Ptr{Cvoid},), music.ptr))
end

function get_volume(music::Music)
    return Real(ccall((:sfMusic_getVolume, libcsfml_audio), Cfloat, (Ptr{Cvoid},), music.ptr))
end

function get_status(music::Music)
    return ccall((:sfMusic_getStatus, libcsfml_audio), Int32, (Ptr{Cvoid},), music.ptr)
end
