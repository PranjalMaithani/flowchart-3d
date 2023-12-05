extends MarginContainer
const DragDraw = preload('../ui/drag/drag_draw.gd')
const ToolButton = preload('../toolbar/tool_button.gd')
const ContainerBox = preload('../../Components/ContainerBox/ContainerBox.tscn')

@onready var tool_mesh: MeshInstance3D = %ToolMesh
@onready var drag_draw: DragDraw = %DragDraw
@onready var tool_button: ToolButton = %ToolButton

@export var initial_mesh: Mesh
var x_scale_unit
var z_scale_unit

var app_manager: AppManager

func update_mesh(value: Mesh):
    tool_mesh.mesh = value
    tool_mesh.visible = false
    tool_mesh.scale = Vector3.ZERO

func _ready():
    #TODO: remove dependency from flowchart_scene node
    app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    app_manager.state.active_tool_changed.connect(on_tool_changed)
    tool_button.initialize({ "on_click": on_click })
    update_mesh(initial_mesh)
    drag_draw.initialize({ "on_start_dragging": on_start_dragging, \
                            "on_stop_dragging": on_stop_dragging, \
                            "container": tool_mesh })

func on_click():
    drag_draw.is_enabled = true

func on_tool_changed(value: Constants.TOOL):
    if(value != Constants.TOOL.CONTAINER):
        drag_draw.is_enabled = false

func on_start_dragging():
    tool_mesh.visible = true

func on_stop_dragging():
    tool_mesh.visible = false
    if(drag_draw.draw_scale.x < 0.5 || drag_draw.draw_scale.z < 0.5):
        return
    var container_box = ContainerBox.instantiate()
    container_box.global_position = tool_mesh.global_position
    app_manager.flowchart_container.add_child(container_box)
    container_box.set_mesh_scale(tool_mesh.scale)

func draw_container():
    tool_mesh.global_position = drag_draw.drag.initial_mouse_position
    tool_mesh.scale = drag_draw.draw_scale

func _process(_delta):
    if(!drag_draw.is_enabled || !drag_draw.drag.is_dragging):
        return
    draw_container()
