class_name UIHelpers

static func is_left_mouse_click(event: InputEvent):
    return event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT

static func get_world_space_from_mouse(space_state: PhysicsDirectSpaceState3D, mouse_position: Vector2, camera: Camera3D):
    var RAY_LENGTH = 1000
    var from = camera.project_ray_origin(mouse_position)
    var to = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH
    var ray_params := PhysicsRayQueryParameters3D.create(from, to)
    ray_params.collide_with_areas = true
    var rayhit := space_state.intersect_ray(ray_params)
    if(rayhit.has("position")):
        return rayhit.position
    
    return null
