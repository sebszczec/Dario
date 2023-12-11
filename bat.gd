extends CharacterBody2D

@onready var timer = $Timer

@export var DirectionChangeTimeout = 2

var generator = RandomNumberGenerator.new()
var direction = Vector2(0, 0)
var lastX = 0

func _ready():
	getRandomStartDirection()
	
	timer.timeout = DirectionChangeTimeout
	timer.start()


@warning_ignore("unused_parameter")
func _physics_process(delta):
	var t1 = "parameters/conditions/IsIdle"
	var t2 = "parameters/conditions/MoveLeft"
	var t3 = "parameters/conditions/MoveRight"
	pass


func getRandomStartDirection():
	while direction.x == 0:
		direction.x = generator.randi_range(-1, 1)


func attack():
	lastX = direction.x
	direction.x = 0


func changeDirection():
	direction.x = -lastX
	lastX = direction.x


func _on_timer_timeout():
	pass # Replace with function body.
