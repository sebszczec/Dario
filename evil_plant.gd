extends CharacterBody2D

@onready var animation = $AnimationPlayer
@onready var hitAnimation = $HitAnimation

var directionTimer = Timer.new()

@export var Timeout = 1.5
var direction = Vector2(0, 0)
const SPEED = 100
var isMoving = true
var isDead = false
var animations = ["Attack_left", "Attack_right"]

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	var generator = RandomNumberGenerator.new()
	var temp = generator.randi_range(-1, 1)
	while temp == 0:
		temp = generator.randi_range(-1, 1)
	direction.x = temp
	if direction.x == -1:
		animations.reverse()
	
	directionTimer.wait_time = Timeout
	directionTimer.one_shot = true
	directionTimer.connect("timeout", _on_directionTimer_timeout)
	add_child(directionTimer)
	directionTimer.start()
	
	animation.play("Idle")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if isMoving:
		velocity.x = direction.x * SPEED
	
	move_and_slide()
	
	var numberOfCollisions = get_slide_collision_count()
	if numberOfCollisions == 0:
		return
	
	for collisionIndex in numberOfCollisions:
		var collision = get_slide_collision(collisionIndex)
		if collision.get_collider().name == "Barrier" and isMoving:
			changeDirection()
			return
		
		if collision.get_collider().name == "Player" and isMoving:
			attack()
			return


var _tempAnimationNumber = 0
func changeDirection():
	_tempAnimationNumber = _tempAnimationNumber + direction.x
	direction = direction * -1


func attack():
	changeDirection()
	isMoving = false
	animation.play(animations[_tempAnimationNumber])


func _on_directionTimer_timeout():
	attack()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Die" or isDead:
		queue_free()
		return
	
	if anim_name == "Attack_left" or anim_name == "Attack_right":
		isMoving = true
		animation.play("Idle")
		directionTimer.start()
		return
	
	
@warning_ignore("unused_parameter")
func _on_heart_box_area_entered(area):
	isDead = true
	directionTimer.stop()
	direction.x = 0
	hitAnimation.play()
	animation.play("Die")

