extends Node3D
const ContainerBox = preload('./container_box.gd')
const PositionUpdater = preload('./position_updater.gd')
const ConnectIn = preload('./connect_in.gd')
const DrawCurve = preload('../curves/draw_curve.gd')
const DragStartPoint = preload('../ui/drag/drag_start_point.gd')
const SnapArea = preload('../ui/snap_area.gd')

@onready var drag_start_point: DragStartPoint = %DragStartPoint
@onready var draw_curve: DrawCurve = %DrawCurve
@onready var area: Area3D = %Area3D
@onready var snap_area: SnapArea = %SnapArea
@onready var position_updater: PositionUpdater = $"../%PositionUpdater"
#TODO: remove dependency from flowchart_scene node
@onready var app_manager: AppManager = get_node("/root/flowchart_scene/AppManager") as AppManager
var parent_container: ContainerBox

var connected_plug: ConnectIn

func check_snap_curve():
    if(snap_area.snapped_object):
        var snap_position = snap_area.snapped_object.global_position
        draw_curve.set_endpoint(Vector3(snap_position.x, position.y, snap_position.z))
        snap_area.snapped_object.set_connection(self)

func update_position(_caller):
    position = position_updater.update_position(self)
    check_snap_curve()

func look_for_connections():
    snap_area.position = to_local(Vector3(drag_start_point.drag.mouse_position.x, position.y, drag_start_point.drag.mouse_position. z))
    check_snap_curve()

func _ready():
    snap_area.set_snap_class(ConnectIn)
    parent_container = get_parent_node_3d()
    position_updater.initialize_position(self)
    parent_container.on_container_changed.connect(update_position)
    drag_start_point.initialize({"area": area, \
                                 "on_start_dragging": on_start_dragging, \
                                 "on_stop_dragging": on_stop_dragging \
                                })

func _process(_delta):
    if(!drag_start_point.drag.is_dragging || app_manager.state.active_tool != Constants.TOOL.SELECT):
        return
    draw_curve.set_endpoint(drag_start_point.drag.mouse_position)
    look_for_connections()

func on_start_dragging():
    draw_curve.enable_curve()
    snap_area.unlock()

func on_stop_dragging():
    if(snap_area.snapped_object == null):
        draw_curve.disable_curve()
    if(snap_area.snapped_object != null):
        snap_area.lock()  
    snap_area.position = Vector3.ZERO
