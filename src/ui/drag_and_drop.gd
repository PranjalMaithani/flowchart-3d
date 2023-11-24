extends Node
var area: Area3D
var was_dragging: bool = false
var is_dragging: bool = false
var on_stop_dragging: Callable
var cursor_shape: Input.CursorShape
var ground_plane
var camera

var initial_mouse_position: Vector3
var mouse_position: Vector3
var mouse_position_difference: Vector3

func _ready():
    #TODO: remove dependency from flowchart_scene node
    var app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    camera = app_manager.camera
    ground_plane = app_manager.ground_plane

func initialize(properties: Dictionary):
    area = properties.area
    area.input_event.connect(handle_mouse_event)
    area.mouse_entered.connect(handle_mouse_enter)
    area.mouse_exited.connect(handle_mouse_exit)
    if(properties.has("on_stop_dragging")):
        on_stop_dragging = properties.on_stop_dragging
    if(properties.has("cursor_shape")):
        cursor_shape = properties.cursor_shape

func handle_mouse_enter():
    if(cursor_shape != null):
        Input.set_default_cursor_shape(cursor_shape)

func handle_mouse_exit():
    Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func update_mouse_position():
    var viewport_mouse_position = get_viewport().get_mouse_position()
    var space_state = area.get_world_3d().direct_space_state
    mouse_position = UIHelpers.get_floor_position_from_mouse(ground_plane, space_state, viewport_mouse_position, camera)

    if(!was_dragging && is_dragging):
        initial_mouse_position = mouse_position
    
    mouse_position_difference = Vector3.ZERO if initial_mouse_position == null \
                                else mouse_position - initial_mouse_position

func handle_dragging(event: InputEventMouseButton):
    is_dragging = event.is_pressed()
    if(is_dragging):
        update_mouse_position()

    was_dragging = is_dragging

func handle_mouse_event(_camera:Node, event:InputEvent, _event_position:Vector3, _normal:Vector3, _shape_idx:int):
    if(is_dragging && Input.is_action_just_released("mouse1")):
        is_dragging = false
        was_dragging = false
        if(on_stop_dragging):
            on_stop_dragging.call()
        return
    
    if(!UIHelpers.is_left_mouse_click(event)):
        return
    handle_dragging(event)

func _process(_delta):
    if(!is_dragging):
        return
    update_mouse_position()
    
