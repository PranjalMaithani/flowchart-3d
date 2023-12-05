extends Resource
class_name AppState

var active_tool: Constants.TOOL
signal active_tool_changed(value: Constants.TOOL)
func set_active_tool(value: Constants.TOOL):
    active_tool = value
    active_tool_changed.emit(value)

var active_object
func set_active_object(value):
    active_object = value

var selected_objects: Array[Node]
