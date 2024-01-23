class_name Mouse
extends RigidBody2D

enum Direction {
	LEFT,
	RIGHT,
	UP,
	DOWN
}

var color = "white" if randf() > 0.5 else "grey"
var direction = Direction.RIGHT

var lastAwayVector = Vector2(0, 0)
var closeRangeMiceChanged = false
var closeRangeMice = {}
var farRangeMiceChanged = false
var farRangeMice = {}
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$BloodSplatter/CPUParticles2D.emitting = false
	_idle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var towardsVector = Vector2(0, 0)
	if player != null:
		lastAwayVector = (get_position() - player.get_position()).normalized() * 100
	elif closeRangeMiceChanged:
		lastAwayVector = Vector2(0, 0)
		for mice in closeRangeMice.keys():
			var awayNow = (get_position() - mice.get_position() + Vector2((randf() - 0.5)* 0.1, (randf() -0.5) * 0.1))
			lastAwayVector += awayNow.normalized() / awayNow.length()
		closeRangeMiceChanged = false
	#for mice in farRangeMice.keys():
		#if mice in closeRangeMice.keys():
			#continue
		#towardsVector += mice.get_position() - get_position()
	
	#set_position(get_position() + awayVector * 0.002 + towardsVector * 0.002)
	if lastAwayVector.length() > 20:
		linear_velocity = lastAwayVector.normalized() * 20
		_move(_closest_to_direction(lastAwayVector, Direction.DOWN))
	else:
		linear_velocity = Vector2.ZERO
		_idle()
	#set_position(get_position() + lastAwayVector.normalized())
	
func _move(dir):
	direction = dir
	$AnimatedSprite2D.play("mouse_%s_move_%s" % [color, Direction.keys()[direction].to_lower()])
	
func _idle():
	$AnimatedSprite2D.play("mouse_%s_idle_%s" % [color, Direction.keys()[direction].to_lower()])


func _on_collision_body_exited(body):
	pass # Replace with function body.


func _on_collision_body_entered(body):
	pass # Replace with function body.


func _on_close_range_body_entered(body):
	pass


func _on_close_range_body_exited(body):
	pass


func _on_far_range_body_entered(body):
	print('entered')
	if body is Roller:
		print("roller entered")
		player = body


func _on_far_range_body_exited(body):
	if body is Roller:
		print("roller exited")
		player = null


func _on_close_range_area_entered(area):
	if area.get_parent() is Mouse:
		closeRangeMice[area.get_parent()] = null
		closeRangeMiceChanged = true

func _on_close_range_area_exited(area):
	if area.get_parent() is Mouse:
		closeRangeMice.erase(area.get_parent())
		closeRangeMiceChanged = true


func _on_far_range_area_entered(area):
	if area.get_parent() is Mouse:
		farRangeMice[area.get_parent()] = null
		farRangeMiceChanged = true


func _on_far_range_area_exited(area):
	if area.get_parent() is Mouse:
		farRangeMice.erase(area.get_parent())
		farRangeMiceChanged = true

func _closest_to_direction(input: Vector2, default: Direction):
	var facing_direction = default
	var current_max_dot = input.dot(_vector_for_dir(default))
	
	for compare_dir in Direction.values():
		var compare_dot = input.dot(_vector_for_dir(compare_dir))
		if compare_dot > current_max_dot:
			facing_direction = compare_dir
			current_max_dot = compare_dot
	
	return facing_direction


func _vector_for_dir(input: Direction):
	match input:
		Direction.RIGHT: return Vector2(1, 0)
		Direction.LEFT: return Vector2(-1, 0)
		Direction.UP: return Vector2(0, -1)
		Direction.DOWN: return Vector2(0, 1)

