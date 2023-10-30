extends Area3D

var drag_and_drop = preload('../ui/drag_and_drop.gd').new({"area": self})
var container

func _ready():
    container = get_parent_node_3d()

func _process(delta):
    if(drag_and_drop.is_dragging):
        container.position.x = drag_and_drop.mouse_position.x
        container.position.z = drag_and_drop.mouse_position.z
