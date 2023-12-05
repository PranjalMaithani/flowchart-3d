extends Area3D

const ContainerBox = preload('./container_box.gd')
const PositionUpdater = preload('./position_updater.gd')
const DragAndDrop = preload('../ui/drag/drag_and_drop.gd')

@export var cursor_shape: Input.CursorShape
@onready var drag_and_drop: DragAndDrop = %DragAndDrop
@onready var container_mesh: MeshInstance3D = $"../%ContainerMesh"
@onready var position_updater: PositionUpdater = $"../%PositionUpdater"

var app_manager: AppManager
var parent_container: ContainerBox
var initial_position: Vector3
var parent_initial_position: Vector3
var initial_scale: Vector3
var camera
var ground_plane

@export var x: int
@export var z: int

func update_position(caller):
    if(caller == self):
        return
    position = position_updater.update_position(self)
    set_intial_values()

func _ready():
    x = 1 if position.x > 0 else -1
    z = 1 if position.z > 0 else -1
    drag_and_drop.initialize({"area": self, "cursor_shape": cursor_shape, "on_stop_dragging": set_intial_values})
    #TODO: remove dependency from flowchart_scene node
    app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    camera = app_manager.camera
    ground_plane = app_manager.ground_plane
    parent_container = get_parent_node_3d()
    set_intial_values()
    parent_container.on_container_changed.connect(update_position)
    position_updater.initialize_position(self)

func set_intial_values():
    initial_position = position
    initial_scale = container_mesh.scale
    parent_initial_position = parent_container.position

func handle_drag():
    var mouse_position_difference = drag_and_drop.drag.mouse_position_difference
    var new_position = initial_position + mouse_position_difference
    position = Vector3(new_position.x, position.y, new_position.z)
    
    var x_diff = position.x - initial_position.x
    var z_diff = position.z - initial_position.z
    var x_scale_delta = position_updater.x_scale_unit * x * x_diff * 2
    var z_scale_delta = position_updater.z_scale_unit * z * z_diff * 2
    var new_x_scale = initial_scale.x + x_scale_delta
    var new_z_scale = initial_scale.z + z_scale_delta
    var new_scale = Vector3(new_x_scale, initial_scale.y, new_z_scale)
    parent_container.on_container_changed.emit(self)
    # var x_middle = parent_initial_position.x + (x * x_diff)
    # var z_middle = parent_initial_position.z + (z * z_diff)
    
    container_mesh.scale = new_scale
    # parent_container.position = Vector3(x_middle, parent_container.position.y, z_middle)
    # parent_container.on_container_changed.emit()

func _process(_delta):
    if(!drag_and_drop.drag.is_dragging || app_manager.state.active_tool != Constants.TOOL.SELECT):
        return
    handle_drag()
