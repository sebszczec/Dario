extends CharacterBody2D

@onready var animationTree = $AnimationTree
@onready var animationPlayer = $AnimationPlayer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum GameStateByte {Attack, Jump, Idle, Run}
var state = []

var isJumping = false
var isAttacking = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	state.append(false) # Attack
	state.append(false) # Jump
	state.append(true) # Idle
	state.append(false) # Run
	pass

func _process(delta):
	updateAnimationParameters()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		isJumping = false
		state[GameStateByte.Jump] = false

	# Handle Jump.
	if Input.is_action_just_pressed("ui_jump") and not isJumping:
		velocity.y = JUMP_VELOCITY
		isJumping = true
		state[GameStateByte.Jump] = true
		
	# Handle Attack
	if Input.is_action_pressed("ui_attack"):
		isAttacking = true
		state[GameStateByte.Attack] = true
		
	if Input.is_action_just_released("ui_attack"):
		isAttacking = false
		state[GameStateByte.Attack] = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if velocity.x == 0:
		state[GameStateByte.Idle] = true
		state[GameStateByte.Run] = false
	else:
		state[GameStateByte.Idle] = false
		state[GameStateByte.Run] = true
	
	move_and_slide()


func updateAnimationParameters():
	if velocity.x != 0:
		animationTree["parameters/Idle/blend_position"] = velocity.normalized().x
		animationTree["parameters/Run/blend_position"] = velocity.normalized().x
		animationTree["parameters/Jump/blend_position"] = velocity.normalized().x
		animationTree["parameters/Attack/blend_position"] = velocity.normalized().x
	
	if isAttacking:
		animationTree["parameters/conditions/is_attacking"] = true
		animationTree["parameters/conditions/is_jumping"] = false
		animationTree["parameters/conditions/is_idle"] = false
		animationTree["parameters/conditions/is_running"] = false
		return
	
	animationTree["parameters/conditions/is_attacking"] = false
	
	if isJumping:
		animationTree["parameters/conditions/is_jumping"] = true
		animationTree["parameters/conditions/is_idle"] = false
		animationTree["parameters/conditions/is_running"] = false
		return

	animationTree["parameters/conditions/is_jumping"] = false
	if velocity.x == 0:
		animationTree["parameters/conditions/is_idle"] = true
		animationTree["parameters/conditions/is_running"] = false
	else:
		animationTree["parameters/conditions/is_idle"] = false
		animationTree["parameters/conditions/is_running"] = true
	

	
		
