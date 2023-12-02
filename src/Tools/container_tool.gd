extends Node3D

var app_manager: AppManager
var ground_plane
var camera

var is_enabled
var is_clicking
var mesh: MeshInstance3D
var mouse_position: Vector3

func _ready():
    #TODO: remove dependency from flowchart_scene node
    app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    camera = app_manager.camera
    ground_plane = app_manager.ground_plane

func set_mesh(value: MeshInstance3D):
    mesh = value

func update_mouse_position():
    var viewport_mouse_position = get_viewport().get_mouse_position()
    var space_state = get_world_3d().direct_space_state
    mouse_position = UIHelpers.get_floor_position_from_mouse(ground_plane, space_state, viewport_mouse_position, camera)

func _process(_delta):
    if(!is_enabled):
        return
    update_mouse_position()