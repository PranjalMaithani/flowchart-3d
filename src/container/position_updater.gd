extends Node3D

const ContainerBox = preload('./container_box.gd')

@onready var container_mesh: MeshInstance3D = $"../%ContainerMesh"
var parent_container: ContainerBox
var x_scale_unit
var z_scale_unit

var initial_values_map: Dictionary

func initialize_position(node: Node3D):
    container_mesh = $"../%ContainerMesh"
    initial_values_map[node.get_instance_id()] = {
        "position": node.position,
        "scale": container_mesh.scale
    }

func _ready():
    parent_container = get_parent_node_3d()
    var aabb_up_left = transform * container_mesh.get_aabb().get_endpoint(0)
    var aabb_down_right = transform * container_mesh.get_aabb().get_endpoint(7)
    x_scale_unit = container_mesh.scale.x / (aabb_down_right.x - aabb_up_left.x)
    z_scale_unit = container_mesh.scale.z / (aabb_down_right.z - aabb_up_left.z)

func update_position(node: Node3D):
    var id = node.get_instance_id()
    var initial_position = initial_values_map[id].position
    var initial_scale = initial_values_map[id].scale

    var x = 1 if initial_position.x > 0 else -1
    var z = 1 if initial_position.z > 0 else -1
    var new_mesh_scale = container_mesh.scale
    var x_scale_delta = new_mesh_scale.x - initial_scale.x
    var z_scale_delta = new_mesh_scale.z - initial_scale.z
    var x_multiplier = 1 / (2 * x_scale_unit)
    var z_multiplier = 1 / (2 * z_scale_unit)
    var x_diff = x_scale_delta * x * x_multiplier
    var z_diff = z_scale_delta * z * z_multiplier
    initial_scale = container_mesh.scale
    return Vector3(initial_position.x + x_diff, initial_position.y, initial_position.z + z_diff)
