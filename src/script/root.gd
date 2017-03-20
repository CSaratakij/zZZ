extends Node

const MENU = {
	"main" : "res://scene/mainmenu.tscn"
}

const LEVEL = [
	"res://scene/level1.tscn",
	"res://scene/gameover.tscn"
]

const SAVE_TEMPLATE = {
	"current_level_id" : 0
}


var current_level_id = 0


func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("force_restart") and not event.is_echo():
		get_tree().reload_current_scene()

	if event.is_action_pressed("force_pause") and not event.is_echo():
		var tree = get_tree()
		tree.set_pause(!tree.is_paused())

func start():
	get_tree().change_scene(LEVEL[0])

func next_scene():
	current_level_id += 1
	get_tree().change_scene(LEVEL[current_level_id])

func mainmenu():
	get_tree().change_scene(MENU["main"])

func _savegame():
	pass

func _loadgame():
	pass
