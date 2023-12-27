class_name Spawner
extends PhysicsBody2D

var health = 3
var untilNext = 500
var randomScene = preload("res://Actors/LessReactive.tscn")
var explosionScene = preload("res://Actors/Explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$AnimatedSprite2D.play("freak_out")
	
func _process(delta):
	untilNext -= 1
	if untilNext < 0:
		untilNext = 500
		var rando = randomScene.instantiate()
		add_sibling(rando)
		rando.set_position(Vector2(randi() % int(get_viewport_rect().size.x), randi() % int(get_viewport_rect().size.y)))

func take_damage(dmg):
	health -= dmg
	if health <= 0:
		var deathExplosion = explosionScene.instantiate()
		add_sibling(deathExplosion)
		deathExplosion.set_position(get_position())
		queue_free()
