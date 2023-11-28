extends Node

@export var MIN = 15.0
@export var MAX = 30.0
@export var SENSITIVITY = 1.0
var camera: Camera3D

func initialize(properties):
    camera = properties.camera

func _ready():
    pass

func _input(event):
    if(!event is InputEventMouseButton):
        return
    if(event.button_index == MOUSE_BUTTON_WHEEL_UP && camera.size > MIN):
        camera.size -= SENSITIVITY;
    if(event.button_index == MOUSE_BUTTON_WHEEL_DOWN && camera.size < MAX   ):
        camera.size += SENSITIVITY;
