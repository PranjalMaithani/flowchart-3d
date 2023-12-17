extends MeshInstance3D
class_name ContainerMesh
const ContainerBox = preload('./container_box.gd')

var container_box: ContainerBox

func initialize(properties: Dictionary):
    container_box = properties.container_box
