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

func get_has_objects_selected():
    return selected_objects.size() > 0

func deslect_all_objects():
    on_deselect_objects.emit()
    selected_objects = []

func delete_selection():
    if(!get_has_objects_selected()):
        return
    for object in selected_objects:
        if("SELECTION_FUNCTIONS" in object && object.SELECTION_FUNCTIONS.has(Constants.SELECTION_FUNCTIONS.DELETE)):
            var delete_method: Callable = object.SELECTION_FUNCTIONS.DELETE
            delete_method.call()
        object.queue_free()
    selected_objects = [] as Array[Node3D]

func execute_selection(class_type, method: StringName, properties):
    if(!get_has_objects_selected()):
        return
    for object in selected_objects:
        if(is_instance_of(object, class_type) && "SELECTION_FUNCTIONS" in object && object.SELECTION_FUNCTIONS.has(method)):
            var object_method: Callable = object.SELECTION_FUNCTIONS[method]
            if(properties == null):
                object_method.call()
            else: 
                object_method.call(properties)

func check_object_in_selection(object):
    return selected_objects.has(object)

func delete_object(object: Node3D):
    var object_index = selected_objects.find(object)
    selected_objects.remove_at(object_index)
    object.queue_free()
