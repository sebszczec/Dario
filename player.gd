extends CharacterBody2D

@onready var animationTree = $AnimationTree
@onready var animationPlayer = $AnimationPlayer
@onready var barrier = $Barrier

@export_category("Character Information")
@export var Life : int = 200

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum GameStateByte {Attack, Jump, Idle, Run}
var state = []

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	state.append(false) # Attack
	state.append(false) # Jump
	state.append(true) # Idle
	state.append(false) # Run


func _process(delta):
	updateStateMachine()
	updateAnimationParameters()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		state[GameStateByte.Jump] = false
	
	# Handle Shield
	barrier.visible = Input.is_action_pressed("ui_shield")

	# Handle Jump.
	if Input.is_action_just_pressed("ui_jump") and not state[GameStateByte.Jump]:
		velocity.y = JUMP_VELOCITY
		state[GameStateByte.Jump] = true
		
	# Handle Attack
	state[GameStateByte.Attack] = Input.is_action_pressed("ui_attack")

	# Handle Movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	state[GameStateByte.Idle] = velocity.x == 0
	state[GameStateByte.Run] = velocity.x != 0
	
	move_and_slide()


func updateStateMachine():
	if state[GameStateByte.Attack]:
		state[GameStateByte.Jump] = false
		state[GameStateByte.Idle] = false
		state[GameStateByte.Run] = false
		return
	
	if state[GameStateByte.Jump]:
		state[GameStateByte.Idle] = false
		state[GameStateByte.Run] = false


func updateAnimationParameters():
	if velocity.x != 0:
		var normal = velocity.normalized().x
		animationTree["parameters/Idle/blend_position"] = normal
		animationTree["parameters/Run/blend_position"] = normal
		animationTree["parameters/Jump/blend_position"] = normal
		animationTree["parameters/Attack/blend_position"] = normal
	
	animationTree["parameters/conditions/is_attacking"] = state[GameStateByte.Attack]
	animationTree["parameters/conditions/is_jumping"] = state[GameStateByte.Jump]
	animationTree["parameters/conditions/is_idle"] = state[GameStateByte.Idle]
	animationTree["parameters/conditions/is_running"] = state[GameStateByte.Run]


	
		
