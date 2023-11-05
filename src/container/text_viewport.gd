@tool
extends SubViewport

@onready var text_panel: PanelContainer = %TextPanel

func _ready():
    print(text_panel.size)

#TODO: update size through events
func _process(delta):
    if(text_panel):
        size = text_panel.size
