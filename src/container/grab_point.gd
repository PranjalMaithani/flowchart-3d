extends Area3D

const ContainerBox = preload('./container_box.gd')
const DragAndDrop = preload('../ui/drag/drag_and_drop.gd')
@onready var container_mesh: MeshInstance3D = $"../%ContainerMesh"
@onready var drag_and_drop: DragAndDrop = %DragAndDrop
var parent_container: ContainerBox
var container
var camera
var ground_plane

var initial_position: Vector3

func _ready():
    container = get_parent_node_3d()
    #TODO: remove dependency from flowchart_scene node
    var app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    camera = app_manager.camera
    ground_plane = app_manager.ground_plane
    parent_container = get_parent_node_3d()
    parent_container.on_container_changed.connect(update_scale)
    drag_and_drop.initialize({"area": self, "on_stop_dragging": on_stop_dragging, "cursor_shape": Input.CURSOR_DRAG})
    initial_position = container.position

func update_scale(_caller):
    scale = container_mesh.scale

func on_stop_dragging():
    initial_position = container.position

func _process(_delta):
    if(drag_and_drop.drag.is_dragging):
        var mouse_position_difference = drag_and_drop.drag.mouse_position_difference
        container.position.x = initial_position.x + mouse_position_difference.x
        container.position.z = initial_position.z + mouse_position_difference.z
        parent_container.on_container_changed.emit(self)
