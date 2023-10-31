extends Area3D

var drag_and_drop = preload('../ui/drag_and_drop.gd').new({"area": self})
@onready var container_mesh: MeshInstance3D = %ContainerMesh
var initial_size: Vector3
var initial_position: Vector3
var camera
var mdt # mesh data tool

@export var x: int
@export var z: int

func _ready():
    #TODO: remove dependency from flowchart_scene node
    var app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    camera = app_manager.camera
    mdt = MeshDataTool.new()
    var mesh := container_mesh.mesh
    var array_mesh = ArrayMesh.new()
    mdt.create_from_surface(mesh, 1)
    print(mdt.get_vertex_count())
    # initial_size = (container_mesh.mesh as BoxMesh).size
    # initial_position = position

func handle_drag():
    var viewport_mouse_position = get_viewport().get_mouse_position()
    var space_state = get_world_3d().direct_space_state
    var mouse_position = UIHelpers.get_world_space_from_mouse(space_state, viewport_mouse_position, camera)

func _process(_delta):
    if(drag_and_drop.is_dragging):
        handle_drag()
