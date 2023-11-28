extends Node

var area: Area3D
var was_dragging: bool
var is_dragging: bool
var mouse_position: Vector3 = Vector3.ZERO

var on_start_dragging: Callable
var on_stop_dragging: Callable

var app_manager: AppManager
var camera
var ground_plane

func _ready():
    #TODO: remove dependency from flowchart_scene node
    app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    camera = app_manager.camera
    ground_plane = app_manager.ground_plane


func _process(_delta):
    if(!is_dragging):
        return
    update_mouse_position()

func initialize(properties: Dictionary):
    area = properties.area
    area.mouse_entered.connect(handle_mouse_enter)
    area.input_event.connect(handle_mouse_event)
    if(properties.has("on_start_dragging")):
        on_start_dragging = properties.on_start_dragging
    if(properties.has("on_stop_dragging")):
        on_stop_dragging = properties.on_stop_dragging

func handle_mouse_enter():
    Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func update_mouse_position():
    var viewport_mouse_position = get_viewport().get_mouse_position()
    var space_state = area.get_world_3d().direct_space_state
    mouse_position = UIHelpers.get_floor_position_from_mouse(ground_plane, space_state, viewport_mouse_position, camera)

func handle_dragging(event: InputEventMouseButton):
    is_dragging = event.is_pressed()
    if(!was_dragging && is_dragging):
        if(on_start_dragging):
            on_start_dragging.call()
    if(is_dragging):
        app_manager.active_object = area
        update_mouse_position()

    was_dragging = is_dragging

func handle_mouse_event(_camera:Node, event:InputEvent, _event_position:Vector3, _normal:Vector3, _shape_idx:int):
    if(!UIHelpers.is_left_mouse_click(event)):
        return
    handle_dragging(event)

func _input(_event):
    if(is_dragging && Input.is_action_just_released("mouse1")):
        app_manager.active_object = null
        is_dragging = false
        was_dragging = false
        if(on_stop_dragging):
            on_stop_dragging.call()