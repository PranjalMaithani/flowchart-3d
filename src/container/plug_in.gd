extends Node3D

@onready var area: Area3D = %Area3D
#TODO: remove dependency from flowchart_scene node
@onready var app_manager: AppManager = get_node("/root/flowchart_scene/AppManager") as AppManager

func _ready():
    pass

func _process(delta):
    pass
