extends Area3D

var drag_and_drop = preload('../ui/drag_and_drop.gd').new({"collider": self})

func handle_drag():
    pass

func _process(_delta):
    if(drag_and_drop.is_dragging):
        handle_drag()
    