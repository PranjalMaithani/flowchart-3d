extends Node
const Drag = preload('../ui/drag/drag.gd')

@onready var drag: Drag = %Drag
var on_stop_dragging: Callable
var app_manager: AppManager

func initialize(properties):
    if(properties.has("on_stop_dragging")):
        on_stop_dragging = properties.on_stop_dragging
    drag.initialize({"on_stop_dragging": on_stop_dragging})

func _ready():
    #TODO: remove dependency from flowchart_scene node
    app_manager = get_node("/root/flowchart_scene/AppManager") as AppManager

func _process(_delta):
    if(!drag.is_dragging || app_manager.state.active_object):
        return
    drag.update_mouse_position()

func _input(event):
    if(app_manager.state.active_object):
        return
    drag.handle_drag_input(event)
