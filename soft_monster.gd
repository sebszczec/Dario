extends Node2D

var dotScene = preload("res://dot.tscn")
var center = Vector2(0, 0)
const HALF_OF_LENGHT = 20
var dots = []

# Called when the node enters the scene tree for the first time.
func _ready():
	center = global_position
	
	for i in 4:
		var dot : CharacterBody2D = dotScene.instantiate()
		dots.append(dot)
	
	dots[0].position.x = -HALF_OF_LENGHT
	dots[0].position.y = -HALF_OF_LENGHT
	
	dots[1].position.x = -HALF_OF_LENGHT
	dots[1].position.y = HALF_OF_LENGHT
	
	dots[2].position.x = HALF_OF_LENGHT
	dots[2].position.y = -HALF_OF_LENGHT
	
	dots[3].position.x = HALF_OF_LENGHT
	dots[3].position.y = HALF_OF_LENGHT
	
	for i in 4:
		add_child(dots[i])
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
