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

var selected_objects: Array[Node3D] = []
signal on_deselect_objects
func select_objects(objects: Array[Node3D]):
    on_deselect_objects.emit()
    selected_objects = objects
    for selected_object in selected_objects:
        if(selected_object.has_method("select")):
            selected_object.select()

func deslect_all_objects():
    on_deselect_objects.emit()
    selected_objects = []
