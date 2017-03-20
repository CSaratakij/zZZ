extends Area2D

var owner
var is_active = false

func _ready():
	set_process(true)

func _process(delta):
	set_hidden(!is_active)

func _on_mark_body_enter( body ):
	if owner and is_active:
		var contacts = body.get_groups()
		if contacts.has("box") or contacts.has("stone"):
			var target = body.get_global_pos()
			body.set_global_pos(owner.get_global_pos())
			owner.set_global_pos(target)
	is_active = false
