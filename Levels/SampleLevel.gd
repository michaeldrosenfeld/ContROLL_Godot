extends Node2D

var mouseScene = preload("res://Actors/Mouse2.tscn")

func _ready():
	#$BackgroundMusic.play()
	for i in range(1, 300):
		var newMouse = mouseScene.instantiate()
		add_child(newMouse)
		newMouse.set_position(Vector2(randi() % int(get_viewport_rect().size.x), randi() % int(get_viewport_rect().size.y)))

func _process(delta):
	pass
