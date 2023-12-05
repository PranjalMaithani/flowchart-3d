extends Node
class_name AppManager

var state: AppState
@export var ground_plane: Node3D
@export var camera: Camera3D
@export var flowchart_container: Node

func _ready():
    state = AppState.new()
