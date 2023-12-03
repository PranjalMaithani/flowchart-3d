extends Resource
class_name AppState

var active_tool: Constants.TOOL

func set_active_tool(value: Constants.TOOL):
    active_tool = value

var active_object
func set_active_object(value):
    active_object = value

var selected_objects: Array[Node]
