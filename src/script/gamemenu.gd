extends Control

func _ready():
	hide()

func _input(event):
	if event.is_action_pressed("toggle_menu") and not event.is_echo():
		set_hidden(!is_hidden())
