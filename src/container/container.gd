extends Node3D

const ResizePoint = preload('./ResizePoint.gd')

@onready var corner_resize_points: Array[ResizePoint]
@onready var edge_resize_points: Array[ResizePoint]
var test: ResizePoint


# Called when the node enters the scene tree for the first time.
func _ready():
    pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
