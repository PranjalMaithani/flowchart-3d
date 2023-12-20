extends Area3D

const ContainerBox = preload('./container_box.gd')
const DragAndDrop = preload('../ui/drag/drag_and_drop.gd')
@onready var container_mesh: MeshInstance3D = $"../%ContainerMesh"
@onready var drag_and_drop: DragAndDrop = %DragAndDrop

var app_manager: AppManager
var app_state: AppState
var parent_container: ContainerBox
var container
var camera
var ground_plane

var initial_position: Vector3

func _ready():
    container = get_parent_node_3d()
    #TODO: remove dependency from flowchart_scene node
    app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    app_state = app_manager.state
    camera = app_manager.camera
    ground_plane = app_manager.ground_plane
    parent_container = get_parent_node_3d()
    parent_container.on_container_changed.connect(update_scale)
    drag_and_drop.initialize({"area": self, "on_stop_dragging": on_stop_dragging, "cursor_shape": Input.CURSOR_DRAG})
    initial_position = container.position

func get_is_in_selection() -> bool:
    return app_state.check_object_in_selection(parent_container)

func update_scale(_caller):
    scale = container_mesh.scale

func execute_on_stop_dragging():
    initial_position = container.position

func on_stop_dragging():
    var is_in_selection = get_is_in_selection()
    if(is_in_selection):
        app_state.execute_selection(ContainerBox, Constants.SELECTION_FUNCTIONS.GRAB_STOP, null)
        return
    execute_on_stop_dragging()

func _process(_delta):
    if(!drag_and_drop.drag.is_dragging || app_manager.state.active_tool != Constants.TOOL.SELECT):
        return
    var mouse_position_difference = drag_and_drop.drag.mouse_position_difference
    var properties = { "mouse_position_difference": drag_and_drop.drag.mouse_position_difference }
    var is_in_selection = get_is_in_selection()
    if(is_in_selection):
        app_state.execute_selection(ContainerBox, Constants.SELECTION_FUNCTIONS.GRAB, properties)
        return
    handle_drag(properties)

func handle_drag(properties: Dictionary):
    print('handle drag clled')
    var mouse_position_difference = properties.mouse_position_difference
    container.position.x = initial_position.x + mouse_position_difference.x
    container.position.z = initial_position.z + mouse_position_difference.z
    parent_container.on_container_changed.emit(self)
