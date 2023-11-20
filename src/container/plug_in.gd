extends Node3D
const ContainerBox = preload('./container_box.gd')
const PositionUpdater = preload('./position_updater.gd')

@onready var area: Area3D = %Area3D
@onready var position_updater: PositionUpdater = $"../%PositionUpdater"
#TODO: remove dependency from flowchart_scene node
@onready var app_manager: AppManager = get_node("/root/flowchart_scene/AppManager") as AppManager
var parent_container: ContainerBox

func update_position(_caller: Area3D):
    position = position_updater.update_position(self)

func _ready():
    parent_container = get_parent_node_3d()
    position_updater.initialize_position(self)
    parent_container.on_container_changed.connect(update_position)

