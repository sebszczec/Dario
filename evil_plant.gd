extends CharacterBody2D

@onready var animation = $AnimationPlayer

var directionTimer = Timer.new()

@export var Timeout = 1.5
var direction = Vector2(1, 0)
const SPEED = 100
var isMoving = true
var animations = ["Attack_left", "Attack_right"]

func _ready():
	directionTimer.wait_time = Timeout
	directionTimer.one_shot = true
	directionTimer.connect("timeout", _on_directionTimer_timeout)
	add_child(directionTimer)
	directionTimer.start()
	
	animation.play("Idle")


func _physics_process(delta):
	if not isMoving:
		return
	velocity = direction * SPEED
	move_and_slide()


var _tempAnimationNumber = 0
func _on_directionTimer_timeout():
	_tempAnimationNumber = _tempAnimationNumber + direction.x
	direction = direction * -1
	isMoving = false
	animation.play(animations[_tempAnimationNumber])


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack_left" or anim_name == "Attack_right":
		isMoving = true
		animation.play("Idle")
		directionTimer.start()
