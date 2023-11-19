extends Node3D
const DragAndDrop = preload('../ui/drag_and_drop.gd')
const CurveMesh3D = preload('res://addons/curvemesh3d/curvemesh3d.gd')
var curve: Curve3D
var curveMesh: CurveMesh3D
var drag_and_drop: DragAndDrop

func _ready():
    curve = Curve3D.new()
    for n in 1:
        curve.add_point(position + Vector3.ONE * n)

func draw_curve(from: Vector3, to: Vector3):
    curve.set_point_position(0, from)
    curve.set_point_position(1, to)