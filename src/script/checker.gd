extends StaticBody2D

var is_detect_box = false


onready var _tree = get_tree()
onready var _root = _tree.get_root()
onready var _global = _root.get_node("/root/root")
onready var _timer = get_node("Timer")


func _ready():
	set_process(true)

func _process(delta):
	if is_detect_box:
		if _timer.get_time_left() == 0:
			_timer.start()

func _on_Area2D_body_enter( body ):
	var contacts = body.get_groups()
	is_detect_box = contacts.has("box")


func _on_Area2D_body_exit( body ):
	var contacts = body.get_groups()
	is_detect_box = !contacts.has("box")

func _on_Timer_timeout():
	_global.next_scene()
