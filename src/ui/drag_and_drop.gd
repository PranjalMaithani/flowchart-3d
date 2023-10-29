extends Node3D
@onready var collider := $Area3D
var is_dragging: bool = false

func _init(properties: Dictionary):
    collider = properties.collider

func _input(event):
    if(!UIHelpers.isLeftMouseClick(event)):
        return
    #TODO: link this with area3D
    if(event.is_action_pressed(MOUSE_BUTTON_LEFT)):
        start_drag()
    if(event.is_action_released(MOUSE_BUTTON_LEFT)):
        stop_drag()

func start_drag():
    is_dragging = true

func stop_drag():
    is_dragging = false


# get mouse_position -> store in mouse class
# Each object has collider with input event