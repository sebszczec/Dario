extends CharacterBody2D

@onready var animation = $AnimationPlayer
@onready var hitAnimation = $HitAnimation

var directionTimer = Timer.new()

@export var Timeout = 1.5
var direction = Vector2(1, 0)
const SPEED = 100
var isMoving = true
var animations = ["Attack_left", "Attack_right"]

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
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
		if collision.get_collider().name == "Player" and isMoving:
			attack()
			return


var _tempAnimationNumber = 0
func attack():
	_tempAnimationNumber = _tempAnimationNumber + direction.x
	direction = direction * -1
	isMoving = false
	animation.play(animations[_tempAnimationNumber])


func _on_directionTimer_timeout():
	attack()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack_left" or anim_name == "Attack_right":
		isMoving = true
		animation.play("Idle")
		directionTimer.start()
		return
	
	if anim_name == "Die":
		queue_free()


func _on_heart_box_area_entered(area):
	directionTimer.stop()
	direction.x = 0
	hitAnimation.play()
	animation.play("Die")

