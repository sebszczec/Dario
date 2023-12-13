extends CharacterBody2D

@onready var explosion = $Explosion
@onready var ball = $Ball
@onready var ballCollision = $BallCollision
@onready var fire1 = $Fire1
@onready var fire2 = $Fire2

@export_category("Positioning")
@export var direction = Vector2(-2, 1)
@export var speed = 200

func _ready():
	pass


func _physics_process(delta):
	velocity = direction * speed
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		setVisibility(false)
		speed = 0
		explosion.explode()
		return


func setVisibility(visible):
	ball.visible = visible
	ballCollision.disabled = !visible
	fire1.emitting = visible
	fire2.emitting = visible


func _on_explosion_exploded():
	queue_free()
