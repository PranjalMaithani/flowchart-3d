extends Node
var area: Area3D
var app_manager: AppManager

func _ready():
    #TODO: remove dependency from flowchart_scene node
    app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager

func _process(delta):
    pass