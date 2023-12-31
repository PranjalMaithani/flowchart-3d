extends Camera3D
const CameraPan = preload('./camera_pan.gd')

@export var PAN_SENSITIVITY = 0.7
@onready var camera_pan = %CameraPan
@onready var camera_zoom = %CameraZoom
var camera_position_node: Node3D

var initial_position: Vector3

func _ready():
    camera_pan.initialize({"on_stop_dragging": on_stop_dragging})
    camera_zoom.initialize({"camera": self})
    initial_position = position
    #TODO: remove dependency from flowchart_scene node
    var app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    camera_position_node = app_manager.camera_position_node

func on_stop_dragging():
    initial_position = position

func _process(_delta):
    if(camera_pan.drag.is_dragging):
        var mouse_position_difference = camera_pan.drag.mouse_position_difference
        position.x = initial_position.x - PAN_SENSITIVITY * mouse_position_difference.x
        position.z = initial_position.z - PAN_SENSITIVITY * mouse_position_difference.z
        camera_position_node.position = position
