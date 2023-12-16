extends CharacterBody2D

var untilNext = 500
var randomScene = preload("res://Actors/LessReactive.tscn")

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
		rando.set_position(Vector2(randi() % 500, randi() % 500))
