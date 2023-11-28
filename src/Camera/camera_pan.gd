extends Node

var was_dragging: bool
var is_dragging: bool

var initial_mouse_position: Vector3
var mouse_position: Vector3
var mouse_position_difference: Vector3
var on_stop_dragging: Callable

var app_manager: AppManager
var camera: Camera3D
var ground_plane

func initialize(properties):
    camera = properties.camera
    if(properties.has("on_stop_dragging")):
        on_stop_dragging = properties.on_stop_dragging

func _ready():
    #TODO: remove dependency from flowchart_scene node
    app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    ground_plane = app_manager.ground_plane

func _process(_delta):
    if(!is_dragging):
        return
    update_mouse_position()

func update_mouse_position():
    if(app_manager.active_object):
        return
    var viewport_mouse_position = get_viewport().get_mouse_position()
    var space_state = camera.get_world_3d().direct_space_state
    mouse_position = UIHelpers.get_floor_position_from_mouse(ground_plane, space_state, viewport_mouse_position, camera)

    if(!was_dragging && is_dragging):
        initial_mouse_position = mouse_position
        if(on_stop_dragging):
            on_stop_dragging.call()
    
    mouse_position_difference = Vector3.ZERO if initial_mouse_position == null \
                                else mouse_position - initial_mouse_position

func handle_dragging():
    is_dragging = true
    update_mouse_position()
    was_dragging = true

func _input(event):
    if(UIHelpers.is_left_mouse_click(event) && event.is_pressed()):
        handle_dragging()
    if(is_dragging && Input.is_action_just_released("mouse1")):
        is_dragging = false
        was_dragging = false
        if(on_stop_dragging):
            on_stop_dragging.call()
