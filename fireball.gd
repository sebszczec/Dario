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
		ball.visible = false
		ballCollision.disabled = true
		fire1.emitting = false
		fire2.emitting = false
		speed = 0
		explosion.explode()



func _on_explosion_exploded():
	queue_free()
