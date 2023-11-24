extends Node3D
const ContainerBox = preload('./container_box.gd')
const PositionUpdater = preload('./position_updater.gd')
const PlugIn = preload('./plug_in.gd')
const DrawCurve = preload('../curves/draw_curve.gd')
const DragStartPoint = preload('../ui/DragPoints/drag_start_point.gd')
const SnapArea = preload('../ui/snap_area.gd')

@onready var drag_start_point: DragStartPoint = %DragStartPoint
@onready var draw_curve: DrawCurve = %DrawCurve
@onready var area: Area3D = %Area3D
@onready var snap_area: SnapArea = %SnapArea
@onready var position_updater: PositionUpdater = $"../%PositionUpdater"
#TODO: remove dependency from flowchart_scene node
@onready var app_manager: AppManager = get_node("/root/flowchart_scene/AppManager") as AppManager
var parent_container: ContainerBox

var connected_plug: PlugIn

func update_position(_caller: Area3D):
    position = position_updater.update_position(self)

func connect_to_plug_in():
    snap_area.position = to_local(Vector3(drag_start_point.mouse_position.x, position.y, drag_start_point.mouse_position. z))
    if(snap_area.snapped_object):
        var snap_position_local = parent_container.to_local(snap_area.snapped_object.global_position)
        draw_curve.set_endpoint(Vector3(snap_position_local.x, position.y, snap_position_local.z))

func _ready():
    snap_area.set_snap_class(PlugIn)
    parent_container = get_parent_node_3d()
    position_updater.initialize_position(self)
    parent_container.on_container_changed.connect(update_position)
    drag_start_point.initialize({"area": area, \
                                 "on_start_dragging": on_start_dragging, \
                                 "on_stop_dragging": on_stop_dragging \
                                })

func _process(_delta):
    if(drag_start_point.is_dragging):
        draw_curve.set_endpoint(drag_start_point.mouse_position)
        connect_to_plug_in()

func on_start_dragging():
    draw_curve.enable_curve()
    snap_area.unlock()

func on_stop_dragging():
    if(snap_area.snapped_object == null):
        draw_curve.disable_curve()
    if(snap_area.snapped_object != null):
        snap_area.lock()  
    snap_area.position = Vector3.ZERO
