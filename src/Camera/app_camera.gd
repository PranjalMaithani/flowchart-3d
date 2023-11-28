extends Camera3D
const CameraPan = preload('./camera_pan.gd')

@export var PAN_SENSITIVITY = 0.7
@onready var camera_pan = %CameraPan

var initial_position: Vector3

func _ready():
    camera_pan.initialize({"camera": self, "on_stop_dragging": on_stop_dragging})

func on_stop_dragging():
    initial_position = position

func _process(_delta):
    if(camera_pan.is_dragging):
        var mouse_position_difference = camera_pan.mouse_position_difference
        position.x = initial_position.x - PAN_SENSITIVITY * mouse_position_difference.x
        position.z = initial_position.z - PAN_SENSITIVITY * mouse_position_difference.z
