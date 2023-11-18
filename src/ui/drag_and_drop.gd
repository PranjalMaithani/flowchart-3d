extends Node
var area: Area3D
var was_dragging: bool = false
var is_dragging: bool = false
var on_stop_dragging: Callable
var cursor_shape: Input.CursorShape

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

func handle_mouse_event(_camera:Node, event:InputEvent, _event_position:Vector3, _normal:Vector3, _shape_idx:int):
    if(!UIHelpers.is_left_mouse_click(event)):
        return

    is_dragging = event.is_pressed()
    if(was_dragging && !is_dragging && on_stop_dragging):
        on_stop_dragging.call()
    
    was_dragging = is_dragging
