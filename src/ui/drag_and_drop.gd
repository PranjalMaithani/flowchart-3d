var area: Area3D
var is_dragging: bool = false
var mouse_position: Vector3

func _init(properties: Dictionary):
    area = properties.area
    area.input_event.connect(handle_mouse_event)

func handle_mouse_event(camera:Node, event:InputEvent, event_position:Vector3, normal:Vector3, shape_idx:int):
    if(!UIHelpers.isLeftMouseClick(event)):
        return

    mouse_position = event_position
    is_dragging = event.is_pressed()
