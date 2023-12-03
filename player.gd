extends CharacterBody2D

@onready var animationTree = $AnimationTree
@onready var animationPlayer = $AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var isJumping = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _process(delta):
	updateAnimationParameters()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		isJumping = false

	# Handle Jump.
	if Input.is_action_just_pressed("ui_jump") and not isJumping:
		velocity.y = JUMP_VELOCITY
		isJumping = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func updateAnimationParameters():
	if isJumping:
		animationTree["parameters/conditions/is_jumping"] = true
		animationTree["parameters/conditions/is_idle"] = false
		animationTree["parameters/conditions/is_running"] = false
	else:
		animationTree["parameters/conditions/is_jumping"] = false

		if velocity.x == 0:
			animationTree["parameters/conditions/is_idle"] = true
			animationTree["parameters/conditions/is_running"] = false
		else:
			animationTree["parameters/conditions/is_idle"] = false
			animationTree["parameters/conditions/is_running"] = true
	
	
	if velocity.x != 0:
		animationTree["parameters/Idle/blend_position"] = velocity.normalized().x
		animationTree["parameters/Run/blend_position"] = velocity.normalized().x
		animationTree["parameters/Jump/blend_position"] = velocity.normalized().x
	
		
