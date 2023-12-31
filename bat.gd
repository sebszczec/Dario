extends CharacterBody2D

@onready var flyTimer = $FlyTimer
@onready var attackTimer = $AttackTimer
@onready var shootingTimer = $ShootingTimer
@onready var animationTree = $AnimationTree

@export var FlyTime = 2
@export var AttackTime = 2
@export var ShootingDelay = 0.2
@export var FlyingSpeed = 100

var fireBallScene = preload("res://fireball.tscn")

var generator = RandomNumberGenerator.new()
var direction = Vector2(0, 0)
var lastX = 0
var isFlying = true
var isCollidingWithWall = false
var numberOfFireBalls = 0
var halfNumberOfFireBalls = 0
var currentFireballIndex = 0
var fireBalls = []

func _ready():
	getRandomStartDirection()
	
	numberOfFireBalls = AttackTime / ShootingDelay
	halfNumberOfFireBalls = numberOfFireBalls / 2
	
	flyTimer.wait_time = FlyTime
	attackTimer.wait_time = AttackTime
	shootingTimer.wait_time = ShootingDelay
	
	flyTimer.start()


func updateAnimation():
	animationTree["parameters/conditions/IsIdle"] = !isFlying
	animationTree["parameters/conditions/IsFlying"] = isFlying
	
	animationTree["parameters/Fly/blend_position"] = direction.x


@warning_ignore("unused_parameter")
func _physics_process(delta):
	var t1 = "parameters/conditions/IsIdle"
	var t2 = "parameters/conditions/IsFlying"
	
	velocity.x = direction.x * FlyingSpeed
	move_and_slide()
	
	var collisionCount = get_slide_collision_count()
	if collisionCount == 0:
		isCollidingWithWall = false
	
	var found = false
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "TileMap":
			found = true
			if isCollidingWithWall == false:
				flyTimer.stop()
				switchToAttack()
				
			isCollidingWithWall = true
	
	isCollidingWithWall = found
	
	updateAnimation()


func getRandomStartDirection():
	while direction.x == 0:
		direction.x = generator.randi_range(-1, 1)


func attack():
	lastX = direction.x
	direction.x = 0
	
	currentFireballIndex = 0
	fireBalls.clear()
	for i in numberOfFireBalls:
		var fireBall = fireBallScene.instantiate()
		fireBall.direction.x = (-halfNumberOfFireBalls + i + 1) / 2
		fireBalls.append(fireBall)
	
	shootingTimer.start()


func changeDirection():
	direction.x = -lastX
	lastX = direction.x


func switchToFly():
	shootingTimer.stop()
	changeDirection()
	isFlying = true
	flyTimer.start()


func _on_attack_timer_timeout():
	switchToFly()


func switchToAttack():
	attack()
	isFlying = false
	attackTimer.start()


func _on_fly_timer_timeout():
	switchToAttack()


func _on_shooting_timer_timeout():
	var fireBall = fireBalls[currentFireballIndex]
	currentFireballIndex = currentFireballIndex + 1
	add_child(fireBall)
