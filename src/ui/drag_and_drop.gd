var area: Area3D
var was_dragging: bool = false
var is_dragging: bool = false
var on_stop_dragging: Callable

func _init(properties: Dictionary):
    area = properties.area
    area.input_event.connect(handle_mouse_event)
    area.mouse_entered.connect(handle_mouse_enter)
    area.mouse_exited.connect(handle_mouse_exit)
    if(properties.has("on_stop_dragging")):
        on_stop_dragging = properties.on_stop_dragging

func handle_mouse_enter():
    Input.set_default_cursor_shape(Input.CURSOR_DRAG)

func handle_mouse_exit():
    Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func handle_mouse_event(_camera:Node, event:InputEvent, _event_position:Vector3, _normal:Vector3, _shape_idx:int):
    if(!UIHelpers.is_left_mouse_click(event)):
        return

    is_dragging = event.is_pressed()
    if(was_dragging && !is_dragging && on_stop_dragging):
        on_stop_dragging.call()
    
    was_dragging = is_dragging
