extends Control

onready var _tree = get_tree()
onready var _root = _tree.get_root()
onready var _global = _root.get_node("/root/root")


func _ready():
	initialize()

func initialize():
	_global.current_level_id = 0
