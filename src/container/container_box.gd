extends Node3D

signal on_container_changed(caller)
@onready var container_mesh = %ContainerMesh
@onready var mesh_scale = container_mesh.scale

func set_mesh_scale(value):
    # called when doing instantiate
    if(!container_mesh):
        container_mesh = get_node("%ContainerMesh")
    container_mesh.scale = value
    on_container_changed.emit(self)
