@static if Sys.iswindows()
    using WinRPM
end

using Libdl

function copy_libs(src, dst)
    files = readdir(src)

    for i = 1:length(files)
        file = files[i]
        if occursin(r"\w*?-\w*?(-.)?.(so|dylib|dll)$", file)
            cp("$src/$file", "$dst/$file", follow_symlinks=true, force=true)
        end
    end
end

function symlink_files(dir, ext)
    cd(dir)
    files = readdir(dir)
    for file in files
        filename = file[1:findfirst(isequal('.'), file) - 1]
        if occursin(r"\w*?-\w*?.(so|dylib|dll)$", file)
            run(`ln -sf $filename.$ext $file`)
        end
    end
end

function mkdir_if_necessary(dir)
    if !isdir(dir)
        mkdir(dir)
    end
end

deps = dirname(@__FILE__)
cd(deps)
const SFML_VERSION="2.5.1"
const CSFML_VERSION="2.0"
const LIB_VERSION="2"

@static if Sys.isapple()
    sfml = "http://www.sfml-dev.org/files/SFML-$(SFML_VERSION)-osx-clang-universal.tar.gz"
    csfml = "http://www.sfml-dev.org/files/CSFML-$(SFML_VERSION)-osx-clang-universal.tar.gz"

    if !isfile("sfml.tar.gz")
        println("Downloading SFML...")
        download(sfml, "sfml.tar.gz")
    end
    if !isfile("csfml.tar.gz")
        println("Downloading CSFML...")
        download(csfml, "csfml.tar.gz")
    end

    mkdir_if_necessary("sfml")
    run(`tar -xzf sfml.tar.gz -C sfml --strip-components=1`)

    mkdir_if_necessary("csfml")
    run(`tar -xzf csfml.tar.gz -C csfml --strip-components=1`)

    symlink_files("$deps/csfml/lib", "$(LIB_VERSION).0.dylib")

    copy_libs("$deps/sfml/lib", deps)
    copy_libs("$deps/csfml/lib", deps)

    cp("$deps/sfml/extlibs/freetype.framework", "$deps/freetype.framework", force=true)
    cp("$deps/sfml/extlibs/sndfile.framework", "$deps/sndfile.framework", force=true)

    cd(deps)
    modules = ["system", "network", "audio", "window", "graphics"]
    for i = 1:length(modules)
        run(`ln -sf libcsfml-$(modules[i]).dylib libcsfml-$(modules[i]).$(SFML_VERSION).dylib`)
    end
end

@static if Sys.islinux()

    modules = ["system", "network", "audio", "window", "graphics"]

    # check if SFML is installed in the system
    useSystemSFML = false

    if !isempty(Libdl.find_library("libcsfml-system"))
        useSystemSFML = true
    end

    if !useSystemSFML  # get our own, but may not work on some platforms [deps]
        sfml = "http://www.sfml-dev.org/files/SFML-$(SFML_VERSION)-linux-gcc-$(Sys.WORD_SIZE)-bit.tar.gz"
        csfml = "http://www.sfml-dev.org/files/CSFML-$(CSFML_VERSION)-linux-gcc-$(Sys.WORD_SIZE)bits.tar.bz2"

        if !isfile("sfml.tar.gz")
            println("Downloading SFML...")
            download(sfml, "sfml.tar.gz")
        end
        if !isfile("csfml.tar.bz2")
            println("Downloading CSFML...")
            download(csfml, "csfml.tar.bz2")
        end

        mkdir_if_necessary("sfml")
        run(`tar -xzf sfml.tar.gz -C sfml --strip-components=1`)

        mkdir_if_necessary("csfml")
        run(`tar -xjf csfml.tar.bz2 -C csfml --strip-components=1`)

        symlink_files("$deps/csfml/lib", "so.$(LIB_VERSION)")

        copy_libs("$deps/sfml/lib", deps)
        copy_libs("$deps/csfml/lib", deps)

        cd(deps)
        for i = 1:length(modules)
            run(`ln -sf libcsfml-$(modules[i]).so libcsfml-$(modules[i]).so.$(LIB_VERSION)`)
            run(`ln -sf libsfml-$(modules[i]).so libsfml-$(modules[i]).so.$(LIB_VERSION)`)
        end
    else
        # use system SFML/CSFML
        # for i = 1:length(modules)
        #     cd(deps)
        #     run(`ln -sf $(systemLibPath)/libcsfml-$(modules[i]).so libcsfml-$(modules[i]).so.$(LIB_VERSION)`)
        #     run(`ln -sf $(systemLibPath)/libsfml-$(modules[i]).so libsfml-$(modules[i]).so`)
        # end
    end
end

@static if Sys.iswindows()
    GCCPath = Pkg.dir("WinRPM","deps","usr","$(Sys.ARCH)-w64-mingw32","sys-root","mingw","bin","gcc.exe")
    if !isfile(GCCPath)
        println("Installing gcc...")
        WinRPM.install("gcc",yes=true)
    end

    cd(deps)
    deps_files = readdir(deps)

    for i = 1:length(deps_files)
        file = deps_files[i]
        if file != "build.jl"
            rm(file, recursive=true)
        end
    end

    println("Downloading SFML and CSFML")
    run(`git clone https://github.com/zyedidia/sfml-binaries.git`)

    mv("sfml-binaries/sfml/sfml-$(Sys.WORD_SIZE)", "sfml")
    mv("sfml-binaries/csfml/csfml-$(Sys.WORD_SIZE)", "csfml")

    copy_libs("$deps/sfml/bin", deps)
    copy_libs("$deps/csfml/bin", deps)
end

cd(joinpath(dirname(@__FILE__),"..","src","c"))
include(joinpath("..", "src", "c", "createlib.jl"))
createlib()
cd(deps)

if isfile("sfml") || isdir("sfml")
    rm("sfml", recursive=true)
end
if isfile("csfml") || isdir("csfml")
    rm("csfml", recursive=true)
end

if isfile("libjuliasfml.dylib") || isfile("libjuliasfml.so") || isfile("libjuliasfml.dll")
    println("Successfully built SFML.jl!")
else
    println("Building SFML.jl failed!")
end
