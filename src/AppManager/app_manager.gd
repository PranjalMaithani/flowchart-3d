extends Node
class_name AppManager

@export var ground_plane: Node3D
@export var camera: Camera3D

var active_object
var selected_objects: Array[Node]