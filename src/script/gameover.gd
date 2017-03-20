extends Control

onready var _tree = get_tree()
onready var _root = _tree.get_root()
onready var _global = _root.get_node("/root/root")

func _on_btnMainmenu_pressed():
	_global.mainmenu()
