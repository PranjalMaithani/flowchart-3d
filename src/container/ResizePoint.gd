extends Area3D

const ContainerBox = preload('./container_box.gd')

var drag_and_drop = preload('../ui/drag_and_drop.gd').new({"area": self, "on_stop_dragging": on_stop_dragging})
@onready var container_mesh: MeshInstance3D = %ContainerMesh
var parent_container: ContainerBox
var initial_position: Vector3
var parent_initial_position: Vector3
var initial_scale: Vector3
var x_scale_unit
var z_scale_unit
var camera
var ground_plane

@export var x: int
@export var z: int

func on_stop_dragging():
    set_intial_values()

func _ready():
    #TODO: remove dependency from flowchart_scene node
    var app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    camera = app_manager.camera
    ground_plane = app_manager.ground_plane
    parent_container = get_parent_node_3d()
    var aabb_up_left = transform * container_mesh.get_aabb().get_endpoint(0)
    var aabb_down_right = transform * container_mesh.get_aabb().get_endpoint(7)
    x_scale_unit = container_mesh.scale.x / (aabb_down_right.x - aabb_up_left.x)
    z_scale_unit = container_mesh.scale.z / (aabb_down_right.z - aabb_up_left.z)
    set_intial_values()
    parent_container.on_container_changed.connect(set_intial_values)

func set_intial_values():
    initial_position = position
    initial_scale = container_mesh.scale
    parent_initial_position = parent_container.position

func handle_drag():
    var viewport_mouse_position = get_viewport().get_mouse_position()
    var space_state = get_world_3d().direct_space_state
    var mouse_position = UIHelpers.get_floor_position_from_mouse(ground_plane, space_state, viewport_mouse_position, camera)
    var mouse_position_local = parent_container.to_local(mouse_position)
    
    var x_diff = position.x - initial_position.x
    var z_diff = position.z - initial_position.z
    var x_scale_delta = x_scale_unit * x_diff * 2
    var z_scale_delta = z_scale_unit * z_diff * 2
    var new_x_scale = initial_scale.x + x_scale_delta
    var new_z_scale = initial_scale.z + z_scale_delta
    var new_scale = Vector3(new_x_scale, initial_scale.y, new_z_scale)
    
    var x_middle = parent_initial_position.x + (x * x_diff)
    var z_middle = parent_initial_position.z + (z * z_diff)
    
    container_mesh.scale = new_scale
    position = Vector3(mouse_position_local.x, position.y, mouse_position_local.z)
    # parent_container.position = Vector3(x_middle, parent_container.position.y, z_middle)
    # parent_container.on_container_changed.emit()
    
func _process(_delta):
    if(drag_and_drop.is_dragging):
        handle_drag()
