extends CharacterBody3D

var speed = 5.0
var mouse_sensitivity = 0.003
var pitch_min = deg_to_rad(-89)
var pitch_max = deg_to_rad(89)
var pitch = 0.0

@onready var pivot = $Pivot
@onready var camera_boom = $Pivot/CameraBoom

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# Horizontal: yaw
		pivot.rotate_y(-event.relative.x * mouse_sensitivity)

		# Vertical: pitch
		pitch += -event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, pitch_min, pitch_max)
		camera_boom.rotation.x = pitch

	elif event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var input_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	var forward = -pivot.transform.basis.z
	var right = pivot.transform.basis.x
	var direction = (right * input_dir.x + forward * input_dir.y).normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	move_and_slide()
