mutable struct RenderWindow
    ptr::Ptr{Cvoid}
    _view::View

    function RenderWindow(ptr::Ptr{Cvoid})
        w = new(ptr)
        w
        # finalizer(w, destroy)
        # w
    end
end
