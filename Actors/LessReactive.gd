extends CharacterBody2D


		#var last_collision = get_last_slide_collision()
		#if last_collision != null:
			#var collision_angle = Vector2.from_angle(last_collision.get_angle())
			#trajectory = trajectory.reflect(collision_angle)
	#else:
		#trajectory = direction.normalized() * WALK_VELOCITY
#
	#velocity = trajectory
	#move_and_slide()

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("run_down")

func _physics_process(delta):
	for collision_idx in get_slide_collision_count():
		var collision = get_slide_collision(collision_idx)
		if collision.get_collider() is Roller:
			print('Roller is collider.')
