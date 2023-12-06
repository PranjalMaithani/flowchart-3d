extends Node

var ground_plane
var camera

var was_dragging: bool = false
var is_dragging: bool = false
var on_stop_dragging: Callable
var on_start_dragging: Callable

var initial_mouse_position: Vector3 = Vector3.ZERO
var mouse_position: Vector3 = Vector3.ZERO
var mouse_position_difference: Vector3 = Vector3.ZERO

var bind: String
var button_index

var is_2D: bool = false

func initialize(properties: Dictionary):
    if(properties.has("on_stop_dragging")):
        on_stop_dragging = properties.on_stop_dragging
    if(properties.has("on_start_dragging")):
        on_start_dragging = properties.on_start_dragging
    if(properties.has("is_2D")):
        is_2D = properties.is_2D
    bind = properties.bind if properties.has("bind") else "mouse1"
    button_index = properties.button_index if properties.has("bind") else MOUSE_BUTTON_LEFT

func _ready():
    #TODO: remove dependency from flowchart_scene node
    var app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    camera = app_manager.camera
    ground_plane = app_manager.ground_plane

func update_mouse_position():
    var viewport_mouse_position = get_viewport().get_mouse_position()
    var space_state = camera.get_world_3d().direct_space_state
    mouse_position = UIHelpers.V2toV3(viewport_mouse_position) if is_2D else \
                     UIHelpers.get_floor_position_from_mouse(ground_plane, space_state, viewport_mouse_position, camera)

    if(!was_dragging && is_dragging):
        initial_mouse_position = mouse_position
    
    mouse_position_difference = Vector3.ZERO if initial_mouse_position == null \
                                else mouse_position - initial_mouse_position

func handle_dragging():
    is_dragging = true
    update_mouse_position()
    was_dragging = true
    if(on_start_dragging):
        on_start_dragging.call()

func handle_drag_input(event):
    var is_required_input = event is InputEventMouseButton and event.button_index == button_index
    if(is_required_input && event.is_pressed()):
        handle_dragging()

func _input(_event):
    if(is_dragging && Input.is_action_just_released(bind)):
        is_dragging = false
        was_dragging = false
        if(on_stop_dragging):
            on_stop_dragging.call()
