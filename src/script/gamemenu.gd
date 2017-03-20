extends Control

onready var _tree = get_tree()
onready var _root = _tree.get_root()
onready var _global = _root.get_node("/root/root")

func _ready():
	hide()
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("toggle_menu") and not event.is_echo():
		set_hidden(!is_hidden())

func _on_btnResume_pressed():
	hide()

func _on_btnMainMenu_pressed():
	_global.mainmenu()

func _on_btnRestart_pressed():
	_tree.reload_current_scene()
