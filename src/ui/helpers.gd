class_name UIHelpers

static func is_left_mouse_click(event: InputEvent):
    return event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT

static func get_floor_position_from_mouse(ground_plane: Node3D, space_state: PhysicsDirectSpaceState3D, mouse_position: Vector2, camera: Camera3D):
    var RAY_LENGTH = 1000
    var from = camera.project_ray_origin(mouse_position)
    var to = from + camera.project_ray_normal(mouse_position) * RAY_LENGTH
    var ray_params := PhysicsRayQueryParameters3D.create(from, to)
    ray_params.collide_with_areas = true
    var ground_plane_static_body = ground_plane.get_node("StaticBody3D") as StaticBody3D
    ray_params.collision_mask = ground_plane_static_body.collision_layer
    var rayhit := space_state.intersect_ray(ray_params)
    if(rayhit.has("position")):
        return rayhit.position
    
    return null

static func V2toV3(value: Vector2) -> Vector3:
    return Vector3(value.x, 0, value.y)

static func get_is_click_outside(event: InputEventMouseButton, mouse_world_space: Vector3, area: Area3D):
    if (event is InputEventMouseButton) and event.pressed:
      var event_local = area.to_local(mouse_world_space)
