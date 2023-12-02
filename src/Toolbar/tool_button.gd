extends Button

var app_manager: AppManager

func _ready():
    pass

func initialize(properties: Dictionary):
    pressed.connect(properties.on_click as Callable)