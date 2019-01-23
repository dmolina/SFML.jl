mutable struct RenderWindow
    ptr::Ptr{CVoid}
    _view::View

    function RenderWindow(ptr::Ptr{CVoid})
        w = new(ptr)
        w
        # finalizer(w, destroy)
        # w
    end
end
