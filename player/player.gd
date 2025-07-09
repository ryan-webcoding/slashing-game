extends CharacterBody2D

@export var speed := 580

var last_direction := "down"
var is_slashing := false
var is_moving := false

func _ready():
	randomize()  # Ensure randi() gives varied results
	$animation_lower.play("idle_down")
	$animation_higher.visible = false

func _process(delta):
	var input_vector = Vector2.ZERO
	var dir = ""

	if Input.is_action_pressed("move_up"):
		input_vector.y -= 1
		dir = "up"
	elif Input.is_action_pressed("move_down"):
		input_vector.y += 1
		dir = "down"
	elif Input.is_action_pressed("move_left"):
		input_vector.x -= 1
		dir = "left"
	elif Input.is_action_pressed("move_right"):
		input_vector.x += 1
		dir = "right"

	is_moving = input_vector != Vector2.ZERO

	# Always move
	if is_moving:
		last_direction = dir
		velocity = input_vector.normalized() * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Animation (only change if not slashing)
	if not is_slashing:
		if is_moving:
			$animation_lower.play("run_" + last_direction)
			$animation_higher.visible = true
			$animation_higher.play("run_" + last_direction)
		else:
			$animation_lower.play("idle_" + last_direction)
			$animation_higher.visible = false

	# Handle slashing key
	if Input.is_action_just_pressed("slash") and not is_slashing:
		is_slashing = true
		if is_moving:
			var anim_name = "run_slash_" + last_direction
			print("🗡️ RUN SLASH:", anim_name)
			$animation_higher.visible = true
			$animation_higher.play(anim_name)
			$animation_higher.connect("animation_finished", _on_slash_finished, CONNECT_ONE_SHOT)
		else:
			var variation = randi() % 2 + 1  # Random 1 or 2
			var anim_name = "idle_slash%d_%s" % [variation, last_direction]
			print("🗡️ IDLE SLASH:", anim_name)
			$animation_lower.play(anim_name)
			$animation_lower.connect("animation_finished", _on_slash_finished, CONNECT_ONE_SHOT)

func _on_slash_finished():
	is_slashing = false
