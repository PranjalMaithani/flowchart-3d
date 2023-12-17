extends Control

const ContainerBox = preload('../container/container_box.gd')
const Drag = preload('../ui/drag/drag.gd')
const BOX_CAST_DEPTH = 3
const BOX_CAST_SCALE_BUFFER = 0.2

@export var box_cast_layer: int
@onready var drag: Drag = %Drag
var selection_box: Panel
var app_state: AppState
var app_manager: AppManager
var ground_plane
var camera: Camera3D
var camera_position_node: Node3D
var shapecast: PhysicsShapeQueryParameters3D
var shape: ConvexPolygonShape3D

func can_use_select():
    return app_state.active_tool == Constants.TOOL.SELECT && !app_state.active_object 

func _ready():
    var hud = get_node("/root/flowchart_scene/%HUD")
    selection_box = hud.get_node("%SelectionBox")
    drag.initialize({ "is_2D": true, "on_stop_dragging": on_stop_dragging })
    #TODO: remove dependency from flowchart_scene node
    app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    app_state = app_manager.state
    camera = app_manager.camera
    camera_position_node = app_manager.camera_position_node
    ground_plane = app_manager.ground_plane
    selection_box.position = Vector2.ZERO
    selection_box.size = Vector2.ZERO
    shapecast = PhysicsShapeQueryParameters3D.new()
    shape = ConvexPolygonShape3D.new()
    shapecast.shape = shape
    shapecast.transform.origin = camera_position_node.position

func _process(_delta):
    if(!can_use_select() || !drag.is_dragging):
        return
    drag.update_mouse_position()
    draw_selection_box()

func _input(event):
    if(!can_use_select()):
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
    if(!can_use_select()):
        return
    check_shapecast()
    selection_box.position = Vector2.ZERO
    selection_box.size = Vector2.ZERO

func get_positions() -> PackedVector3Array:
    var direct_space_state = camera.get_world_3d().direct_space_state
    var p0 = Vector3(0, 0, 0)
    var p1_mouse_pos = drag.initial_mouse_position_2d
    var p1_global = UIHelpers.get_floor_position_from_mouse(ground_plane, direct_space_state, p1_mouse_pos, camera)
    var p1 = camera_position_node.to_local(p1_global)
    var p2_mouse_pos = drag.initial_mouse_position_2d + Vector2(drag.mouse_position_difference_2d.x, 0.0)
    var p2_global = UIHelpers.get_floor_position_from_mouse(ground_plane, direct_space_state, p2_mouse_pos, camera)
    var p2 = camera_position_node.to_local(p2_global)
    var p3_mouse_pos = drag.initial_mouse_position_2d + Vector2(drag.mouse_position_difference_2d.x, drag.mouse_position_difference_2d.y)
    var p3_global = UIHelpers.get_floor_position_from_mouse(ground_plane, direct_space_state, p3_mouse_pos, camera)
    var p3 = camera_position_node.to_local(p3_global)
    var p4_mouse_pos = drag.initial_mouse_position_2d + Vector2(0.0, drag.mouse_position_difference_2d.y)
    var p4_global = UIHelpers.get_floor_position_from_mouse(ground_plane, direct_space_state, p4_mouse_pos, camera)
    var p4 = camera_position_node.to_local(p4_global)
    return [p0, p1, p2, p3, p4]

func check_shapecast():
    var direct_space_state = camera.get_world_3d().direct_space_state
    shapecast.transform.origin = camera_position_node.position
    var points = get_positions()
    shape.set_points(points)
    shapecast.shape = shape
    var collisions: Array[Dictionary] = direct_space_state.intersect_shape(shapecast)
    var collision_count: int = collisions.size()
    if(collision_count < 1):
        app_state.deslect_all_objects()
        return

    var container_box_array: Array[Node3D] = []
    for collision in collisions:
        var collider = collision.collider
        var parent_node = collider.get_parent_node_3d()
        if(!parent_node is ContainerMesh):
            continue
        var container_box: ContainerBox = parent_node.container_box
        container_box_array.push_back(container_box)

    app_state.select_objects(container_box_array)
