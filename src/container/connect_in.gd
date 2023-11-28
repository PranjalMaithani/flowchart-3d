extends Area3D
const ContainerBox = preload('./container_box.gd')
const PositionUpdater = preload('./position_updater.gd')
const ConnectOut = preload('./connect_out.gd')

@onready var position_updater: PositionUpdater = $"../%PositionUpdater"
#TODO: remove dependency from flowchart_scene node
@onready var app_manager: AppManager = get_node("/root/flowchart_scene/AppManager") as AppManager
var parent_container: ContainerBox
var connected_node: ConnectOut

func update_position(_caller: Area3D):
    position = position_updater.update_position(self)
    update_connected_node()

func _ready():
    parent_container = get_parent_node_3d()
    position_updater.initialize_position(self)
    parent_container.on_container_changed.connect(update_position)

func set_connection(value: ConnectOut):
    connected_node = value

func update_connected_node():
    if(connected_node == null):
        return
    connected_node.update_position(self)
