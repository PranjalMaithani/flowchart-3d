extends Node

var app_manager: AppManager
var app_state: AppState

func _ready():
    #TODO: remove dependency from flowchart_scene node
    app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    app_state = app_manager.state

func handle_delete_key():
    app_state.delete_selection()

func _input(event):
    if(!event is InputEventKey || !event.is_pressed()):
        return
    if(event.keycode == KEY_DELETE):
        handle_delete_key()
