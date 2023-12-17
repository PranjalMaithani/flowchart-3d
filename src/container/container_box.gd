extends Node3D

signal on_container_changed(caller)
@onready var container_mesh = %ContainerMesh
@onready var outline_mesh: MeshInstance3D = %OutlineMesh
@onready var mesh_scale = container_mesh.scale
var app_state: AppState

var outline_scale_difference: float

func _ready():
    #TODO: remove dependency from flowchart_scene node
    var app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    app_state = app_manager.state
    container_mesh.initialize({ "container_box": self })
    outline_scale_difference = outline_mesh.scale.x - container_mesh.scale.x #assuming x y z are same
    on_container_changed.connect(set_outline_scale)
    outline_mesh.visible = false
    app_state.on_deselect_objects.connect(deselect)

func set_mesh_scale(value: Vector3):
    # called when doing instantiate
    if(!container_mesh):
        container_mesh = get_node("%ContainerMesh")
    container_mesh.scale = value
    outline_mesh.scale = value * outline_scale_difference
    on_container_changed.emit(self)

func select():
    outline_mesh.visible = true

func deselect():
    outline_mesh.visible = false

func set_outline_scale(_caller):
    var difference = Vector3(outline_scale_difference, outline_scale_difference, outline_scale_difference)
    outline_mesh.scale = container_mesh.scale + difference
