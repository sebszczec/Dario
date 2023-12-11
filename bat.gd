extends CharacterBody2D

@onready var flyTimer = $FlyTimer
@onready var attackTimer = $AttackTimer

@export var FlyTime = 2
@export var AttackTime = 2
@export var FlyingSpeed = 100

var generator = RandomNumberGenerator.new()
var direction = Vector2(0, 0)
var lastX = 0

func _ready():
	getRandomStartDirection()
	
	flyTimer.wait_time = FlyTime
	attackTimer.wait_time = AttackTime
	
	flyTimer.start()


@warning_ignore("unused_parameter")
func _physics_process(delta):
	var t1 = "parameters/conditions/IsIdle"
	var t2 = "parameters/conditions/MoveLeft"
	var t3 = "parameters/conditions/MoveRight"
	
	velocity.x = direction.x * FlyingSpeed
	move_and_slide()
	
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


func _on_attack_timer_timeout():
	changeDirection()
	flyTimer.start()


func _on_fly_timer_timeout():
	attack()
	attackTimer.start()
