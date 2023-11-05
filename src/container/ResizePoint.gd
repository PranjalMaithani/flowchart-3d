extends Area3D

const ContainerBox = preload('./container_box.gd')

var drag_and_drop = preload('../ui/drag_and_drop.gd').new({"area": self, "on_stop_dragging": on_stop_dragging})
@onready var container_mesh: MeshInstance3D = %ContainerMesh
var parent_container: ContainerBox
var initial_position: Vector3
var intial_scale: Vector3
var camera

@export var x: int
@export var z: int

func on_stop_dragging():
    pass

func _ready():
    #TODO: remove dependency from flowchart_scene node
    var app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    camera = app_manager.camera
    parent_container = get_parent_node_3d()
    set_intial_values()
    parent_container.on_container_changed.connect(set_intial_values)

func set_intial_values():
    initial_position = to_local(position)
    intial_scale = container_mesh.scale

func handle_drag():
    var viewport_mouse_position = get_viewport().get_mouse_position()
    var space_state = get_world_3d().direct_space_state
    var mouse_position = UIHelpers.get_world_space_from_mouse(space_state, viewport_mouse_position, camera)
    var mouse_position_3d = Vector3(mouse_position.x, 0, mouse_position.z)
    var mouse_position_local = to_local(mouse_position_3d)
    var x_diff = mouse_position_local.x - initial_position.x
    var z_diff = mouse_position_local.z - initial_position.z
    var new_scale = Vector3(x_diff * intial_scale.x + intial_scale.x, intial_scale.y, z_diff * intial_scale.z + intial_scale.z)

    var x_middle = initial_position.x + x_diff / 2
    var z_middle = initial_position.z + z_diff / 2

    container_mesh.scale = new_scale
    parent_container.position = Vector3(x_middle, container_mesh.position.y, z_middle)

func _process(_delta):
    if(drag_and_drop.is_dragging):
        handle_drag()
