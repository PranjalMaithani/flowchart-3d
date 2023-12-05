extends Button

var app_manager: AppManager
var on_click: Callable
@export var tool_name: Constants.TOOL

func _ready():
    #TODO: remove dependency from flowchart_scene node
    app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager
    pressed.connect(handle_click)

func initialize(properties: Dictionary):
    on_click = properties.on_click

func handle_click():
    app_manager.state.set_active_tool(tool_name)
    if(on_click):
        on_click.call()
