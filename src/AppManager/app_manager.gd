extends Node
class_name AppManager

var state: AppState = AppState.new()
@export var ground_plane: Node3D
@export var camera: Camera3D
@export var flowchart_container: Node
@export var camera_position_node: Node3D

func _ready():
    camera_position_node.position = camera.position
