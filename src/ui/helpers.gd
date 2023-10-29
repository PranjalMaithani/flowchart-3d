class_name UIHelpers

static func isLeftMouseClick(event: InputEvent):
    return event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT
