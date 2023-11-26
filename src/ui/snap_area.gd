extends Area3D

var is_locked: bool
var snap_class
var snapped_object = null

func set_snap_class(value):
    snap_class = value

func _ready():
    area_entered.connect(check_object_snapping)
    area_exited.connect(exit_area)

func unlock():
    is_locked = false
    snapped_object = null

func lock():
    is_locked = true

func exit_area(body: Node3D):
    if(is_locked):
        return
    if(snap_class != null && is_instance_of(body, snap_class)):
        snapped_object = null

func check_object_snapping(body: Node3D):
    if(is_locked):
        return
    var has_snap_object = snap_class != null && is_instance_of(body, snap_class)
    snapped_object = body if has_snap_object else null
