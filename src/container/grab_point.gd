extends Area3D

const ContainerBox = preload('./container_box.gd')
@onready var container_mesh: MeshInstance3D = %ContainerMesh
var parent_container: ContainerBox
var drag_and_drop = preload('../ui/drag_and_drop.gd').new({"area": self, "on_stop_dragging": on_stop_dragging, "cursor_shape": Input.CURSOR_DRAG})
var container
var camera
var ground_plane

func _ready():
    container = get_parent_node_3d()
    #TODO: remove dependency from flowchart_scene node
    var app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    camera = app_manager.camera
    ground_plane = app_manager.ground_plane
    parent_container = get_parent_node_3d()
    parent_container.on_container_changed.connect(update_scale)

func update_scale(_caller):
    scale = container_mesh.scale

func on_stop_dragging():
    parent_container.on_container_changed.emit()

func _process(_delta):
    if(drag_and_drop.is_dragging):
        var viewport_mouse_position = get_viewport().get_mouse_position()
        var space_state = get_world_3d().direct_space_state
        var mouse_position = UIHelpers.get_floor_position_from_mouse(ground_plane, space_state, viewport_mouse_position, camera)
        container.position.x = mouse_position.x
        container.position.z = mouse_position.z
