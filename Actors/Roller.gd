class_name Roller
extends CharacterBody2D


const WALK_VELOCITY = 125
const ROLL_VELOCITY = 350
const ROLL_ANGLE_CHANGE = 0.1

var trajectory = Vector2(0, 0)
var last_processed_collision = null


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
	
	var last_collision = get_last_slide_collision()
	if last_collision != null and last_collision != last_processed_collision:
		if last_collision.get_collider() is LessReactive:
			#last_collision.get_collider().set_position(last_collision.get_collider().get_position() + Vector2(0, 10))
			var impulse = -last_collision.get_normal() * trajectory.length()
			last_collision.get_collider().apply_central_impulse(impulse)
			last_processed_collision = last_collision
		elif last_collision.get_collider() is Spawner:
			last_collision.get_collider().take_damage(1)
		
	#var collided_with = {}
	#for collision_idx in get_slide_collision_count():
		#var collision = get_slide_collision(collision_idx)
		#if collided_with.get(collision.get_collider(), false):
			#continue
#
		#if collision.get_collider() is LessReactive:
			#collided_with[collision.get_collider()] = true
			#collision.get_collider().set_position(collision.get_collider().get_position() + Vector2(0, 10))
			##collision.get_collider().apply_central_impulse(-collision.get_normal() * 50.0)
