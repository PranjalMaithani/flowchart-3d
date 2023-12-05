extends Node
const Drag = preload('./drag.gd')

@onready var drag: Drag = %Drag
var is_enabled: bool = false
var on_stop_dragging: Callable
var on_start_dragging: Callable
var app_manager: AppManager

var draw_scale: Vector3 = Vector3.ZERO
var x_scale_unit
var z_scale_unit

func initialize(properties):
    if(properties.has("on_stop_dragging")):
        on_stop_dragging = properties.on_stop_dragging
    if(properties.has("on_start_dragging")):
        on_start_dragging = properties.on_start_dragging
    drag.initialize({"on_stop_dragging": handle_stop_dragging, \
                     "on_start_dragging": on_start_dragging, \
                    })
    set_scale_units(properties.container)

func _ready():
    #TODO: remove dependency from flowchart_scene node
    app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager

func _process(_delta):
    if(!is_enabled || !drag.is_dragging):
        return
    drag.update_mouse_position()
    handle_dragging()

func _input(event):
    if(!is_enabled):
        return
    drag.handle_drag_input(event)

func set_scale_units(container: Node3D):
    var aabb_up_left = container.get_aabb().get_endpoint(0)
    var aabb_down_right = container.get_aabb().get_endpoint(7)
    x_scale_unit = 1 / (aabb_down_right.x - aabb_up_left.x)
    z_scale_unit = 1 / (aabb_down_right.z - aabb_up_left.z)

func handle_dragging():
    var mouse_position_difference = drag.mouse_position_difference
    var x_scale_delta = x_scale_unit * mouse_position_difference.x * 2
    var z_scale_delta = z_scale_unit * mouse_position_difference.z * 2
    var x_scale = x_scale_delta
    var z_scale = z_scale_delta
    draw_scale = Vector3(x_scale, 1, z_scale)

func handle_stop_dragging():
    if(on_stop_dragging):
        on_stop_dragging.call()
    draw_scale = Vector3.ZERO
