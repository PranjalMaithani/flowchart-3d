extends Node3D
const CurveMesh3D = preload('res://addons/curvemesh3d/curvemesh3d.gd')
var curve: Curve3D
@onready var curveMesh: CurveMesh3D = %CurveMesh3D

func _ready():
    curve = Curve3D.new()
    #TODO: draw better curves instead of linear
    for n in 2:
        curve.add_point(position)
    curveMesh.curve = curve
    disable_curve()

func set_endpoint(endpoint: Vector3):
    var endpoint_local = to_local(endpoint)
    curve.set_point_position(1, endpoint_local)

func enable_curve():
    visible = true

func disable_curve():
    visible = false
