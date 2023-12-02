extends Button

var app_manager: AppManager
@export var tool_name: Constants.TOOL

func _ready():
    pass

func initialize(properties: Dictionary):
    app_manager.state.set_active_tool(tool_name)
    pressed.connect(properties.on_click as Callable)
