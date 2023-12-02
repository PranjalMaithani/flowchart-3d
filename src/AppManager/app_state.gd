extends Resource
class_name AppState

var active_tool: Constants.TOOL

func set_active_tool(value: Constants.TOOL):
    active_tool = value

var active_object
var selected_objects: Array[Node]
