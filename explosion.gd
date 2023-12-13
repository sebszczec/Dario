extends Node2D


@onready var fire1 = $Fire1
@onready var fire2 = $Fire2
@onready var animationPlayer = $AnimationPlayer

signal exploded

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func explode():
	fire1.emitting = true
	fire2.emitting = true
	animationPlayer.play("Explode")


func _on_animation_player_animation_finished(anim_name):
	exploded.emit()
