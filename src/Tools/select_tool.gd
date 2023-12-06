extends Control

const Drag = preload('../ui/drag/drag.gd')

@onready var drag: Drag = %Drag
var selection_box: Panel
var app_state: AppState

func _ready():
    var hud = get_node("/root/flowchart_scene/%HUD")
    selection_box = hud.get_node("%SelectionBox")
    drag.initialize({ "is_2D": true, "on_stop_dragging": on_stop_dragging })
    #TODO: remove dependency from flowchart_scene node
    var app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    app_state = app_manager.state
    selection_box.position = Vector2.ZERO
    selection_box.size = Vector2.ZERO

func _process(_delta):
    if(app_state.active_tool != Constants.TOOL.SELECT || !drag.is_dragging || app_state.active_object):
        return
    drag.update_mouse_position()
    draw_selection_box()

func _input(event):
    if(app_state.active_tool != Constants.TOOL.SELECT || app_state.active_object):
        return
    drag.handle_drag_input(event)

func draw_selection_box():
    var x_pos = (drag.initial_mouse_position.x - abs(drag.mouse_position_difference.x)) if drag.mouse_position_difference.x < 0 else drag.initial_mouse_position.x
    var z_pos = (drag.initial_mouse_position.z - abs(drag.mouse_position_difference.z)) if drag.mouse_position_difference.z < 0 else drag.initial_mouse_position.z
    var x_scale = abs(drag.mouse_position_difference.x)
    var z_scale = abs(drag.mouse_position_difference.z)
    selection_box.position = Vector2(x_pos, z_pos)
    selection_box.size = Vector2(x_scale, z_scale)

func on_stop_dragging():
    selection_box.position = Vector2.ZERO
    selection_box.size = Vector2.ZERO
