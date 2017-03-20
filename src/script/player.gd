extends RigidBody2D

const GRAVITY = 9.8
const MOVE_FORCE = 300
const JUMP_FORCE = 400

const MAX_JUMP = 3
const MAX_RAYCHECKER_LENGTH = 1000

const AIM_COLOR = Color(255, 255, 0)
const AIM_WEIGHT = 3


var total_jump = 0

var move_dir = Vector2(0.0, 0.0)
var mouse_pos = Vector2(0.0, 0.0)
var screen_mouse_pos = Vector2(0.0, 0.0)

var is_alive = true
var is_facing_right = true
var is_jumping = false
var is_grounded = false
var is_throwing_mark = false


onready var _tree = get_tree()
onready var _raycast = get_node("RayCast2D")
onready var _ray_checker = get_node("RayChecker")
onready var _camera = get_node("Camera2D")
onready var _mark = get_node("mark")


func _ready():
	initialize()
	set_process(true)
	set_process_input(true)
	set_fixed_process(true)

func initialize():
	if _raycast and !_raycast.is_enabled():
		_raycast.set_enabled(true)

	if _ray_checker and !_ray_checker.is_enabled():
		_ray_checker.set_enabled(true)

	if _mark:
		_mark.is_active = false
		_mark.owner = self

func _input(event):
	if is_alive:
		if event.is_action_pressed("jump") and !event.is_echo():
			is_jumping = true
			total_jump += 1

		elif event.is_action_released("jump") and !event.is_echo():
			is_jumping = false

		if event.is_action_pressed("throw_target") and !event.is_echo():
			is_throwing_mark = true

		elif event.is_action_released("throw_target") and !event.is_echo():
			is_throwing_mark = false

		if event.type == InputEvent.MOUSE_MOTION:
			screen_mouse_pos.x = event.x
			screen_mouse_pos.y = event.y
	else:
		is_jumping = false
		is_throwing_mark = false
		total_jump = 0
		mouse_pos = Vector2(0.0, 0.0)

func _draw():
		draw_set_transform_matrix(get_global_transform().affine_inverse())
		if _ray_checker.is_colliding():
			draw_line(get_pos(), _ray_checker.get_collision_point(), AIM_COLOR, AIM_WEIGHT)
		else:
			draw_line(get_pos(), _camera.get_global_mouse_pos(), AIM_COLOR, AIM_WEIGHT)

func _process(delta):
	if is_alive:
		if Input.is_action_pressed("move_left"):
			move_dir.x = -1.0
		elif Input.is_action_pressed("move_right"):
			move_dir.x = 1.0
		else:
			move_dir.x = 0.0

		mouse_pos = _camera.get_global_mouse_pos()

		var result = mouse_pos - get_global_pos()
		result = result.normalized() * MAX_RAYCHECKER_LENGTH

		_ray_checker.set_cast_to(result)

		if is_throwing_mark:
			if _ray_checker.is_colliding():
				_mark.is_active = true
				_mark.set_global_pos(_ray_checker.get_collision_point())
			is_throwing_mark = false
	else:
		move_dir.x = 0.0

	update()

func _fixed_process(delta):
	is_grounded = _raycast.is_colliding()
	if is_grounded:
		total_jump = 0

func _integrate_forces(state):
	state.integrate_forces()
	set_applied_force(Vector2(0.0, GRAVITY))

	var lv = state.get_linear_velocity()
	var result_lv = Vector2(0.0, lv.y + GRAVITY)

	if is_alive:
		result_lv.x = move_dir.x * MOVE_FORCE
		if is_jumping and total_jump < MAX_JUMP:
			result_lv.y = -JUMP_FORCE
			is_jumping = false
	else:
		result_lv.x = 0.0

	state.set_linear_velocity(result_lv)
