class_name Roller extends CharacterBody2D


const WALK_VELOCITY = 125
const ROLL_VELOCITY = 250
const ROLL_ANGLE_CHANGE = 0.05

var trajectory = Vector2(0, 0)


func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_action_pressed("ui_right_trigger"):
		if direction != Vector2.ZERO:
			var angle_delta = trajectory.angle_to(direction)
			if angle_delta > PI * 2:
				angle_delta -= PI * 2
			elif angle_delta < -PI * 2:
				angle_delta += PI * 2
			
			angle_delta = clamp(angle_delta, -ROLL_ANGLE_CHANGE, ROLL_ANGLE_CHANGE)
			trajectory = trajectory.rotated(angle_delta)

		trajectory = trajectory.normalized() * ROLL_VELOCITY
		var last_collision = get_last_slide_collision()
		if last_collision != null:
			var collision_angle = Vector2.from_angle(last_collision.get_angle())
			trajectory = trajectory.reflect(collision_angle)
	else:
		trajectory = direction.normalized() * WALK_VELOCITY

	velocity = trajectory
	move_and_slide()
