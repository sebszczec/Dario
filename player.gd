extends CharacterBody2D

@onready var animationTree = $AnimationTree
@onready var animationPlayer = $AnimationPlayer
@onready var barrier = $Barrier

@export_category("Character Information")
@export var Life : int = 100

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

enum PlayerStateByte {Attack, Jump, Idle, Run}
var state = []
var isDead = false

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


func handle_Is_Action_Pressed(actionName):
	if isDead == true:
		return false
		
	return Input.is_action_pressed(actionName)


func handle_Is_Action_Just_Pressed(actionName):
	if isDead == true:
		return false
		
	return Input.is_action_just_pressed(actionName)
	
	
func handle_Get_Axis(actionName1, actionName2):
	if isDead == true:
		return Vector2(0, 0)
		
	return Input.get_axis(actionName1, actionName2)


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		state[PlayerStateByte.Jump] = false
	
	# Handle Shield
	barrier.visible = handle_Is_Action_Pressed("ui_shield")

	# Handle Jump.
	if handle_Is_Action_Just_Pressed("ui_jump") and not state[PlayerStateByte.Jump]:
		velocity.y = JUMP_VELOCITY
		state[PlayerStateByte.Jump] = true
		
	# Handle Attack
	state[PlayerStateByte.Attack] = handle_Is_Action_Pressed("ui_attack")

	# Handle Movement
	var direction = handle_Get_Axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	state[PlayerStateByte.Idle] = velocity.x == 0
	state[PlayerStateByte.Run] = velocity.x != 0
	
	move_and_slide()


func updateStateMachine():
	if state[PlayerStateByte.Attack]:
		state[PlayerStateByte.Jump] = false
		state[PlayerStateByte.Idle] = false
		state[PlayerStateByte.Run] = false
		return
	
	if state[PlayerStateByte.Jump]:
		state[PlayerStateByte.Idle] = false
		state[PlayerStateByte.Run] = false


func updateAnimationParameters():
	if velocity.x != 0:
		var normal = velocity.normalized().x
		animationTree["parameters/Idle/blend_position"] = normal
		animationTree["parameters/Run/blend_position"] = normal
		animationTree["parameters/Jump/blend_position"] = normal
		animationTree["parameters/Attack/blend_position"] = normal	
	
	animationTree["parameters/conditions/is_attacking"] = state[PlayerStateByte.Attack]
	animationTree["parameters/conditions/is_jumping"] = state[PlayerStateByte.Jump]
	animationTree["parameters/conditions/is_idle"] = state[PlayerStateByte.Idle]
	animationTree["parameters/conditions/is_running"] = state[PlayerStateByte.Run]


func _on_heart_box_area_entered(area):
	if Life > 0:
		Life = Life - 50
	
	if Life <= 0:
		animationTree.active = false
		isDead = true
		animationPlayer.play("Die")
	
	
