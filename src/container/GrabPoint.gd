extends Area3D

var drag_and_drop = preload('../ui/drag_and_drop.gd').new({"area": self})
var container
var camera

func _ready():
    container = get_parent_node_3d()
    #TODO: remove dependency from flowchart_scene node
    var app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    camera = app_manager.camera

func _process(delta):
    if(drag_and_drop.is_dragging):
        var viewport_mouse_position = get_viewport().get_mouse_position()
        var space_state = get_world_3d().direct_space_state
        var mouse_position = UIHelpers.get_world_space_from_mouse(space_state, viewport_mouse_position, camera)
        container.position.x = mouse_position.x
        container.position.z = mouse_position.z
