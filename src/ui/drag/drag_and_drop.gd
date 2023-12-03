extends Node
const Drag = preload('./drag.gd')

@onready var drag: Drag = %Drag
var area: Area3D
var cursor_shape: Input.CursorShape
var app_manager: AppManager

var on_start_dragging: Callable
var on_stop_dragging: Callable

func _ready():
    #TODO: remove dependency from flowchart_scene node
    app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager

func _process(_delta):
    if(drag.is_dragging):
        drag.update_mouse_position()

func initialize(properties: Dictionary):
    area = properties.area
    area.input_event.connect(handle_mouse_event)
    area.mouse_entered.connect(handle_mouse_enter)
    area.mouse_exited.connect(handle_mouse_exit)
    if(properties.has("cursor_shape")):
        cursor_shape = properties.cursor_shape
    if(properties.has("on_start_dragging")):
        on_start_dragging = properties.on_start_dragging
    if(properties.has("on_stop_dragging")):
        on_stop_dragging = properties.on_stop_dragging
    drag.initialize({"on_stop_dragging": handle_stop_dragging, \
                     "on_start_dragging": handle_start_dragging})

func handle_mouse_enter():
    if(cursor_shape != null):
        Input.set_default_cursor_shape(cursor_shape)

func handle_mouse_exit():
    Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func handle_mouse_event(_camera:Node, event:InputEvent, _event_position:Vector3, _normal:Vector3, _shape_idx:int):
    drag.handle_drag_input(event)

func handle_start_dragging():
    app_manager.state.set_active_object(area)
    if(on_start_dragging):
        on_start_dragging.call()

func handle_stop_dragging():
    app_manager.state.set_active_object(null)
    if(on_stop_dragging):
        on_stop_dragging.call()
