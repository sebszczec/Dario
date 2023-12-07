extends Node2D

@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer


func _ready():
	sprite.visible = false


func play():
	sprite.visible = true
	animationPlayer.play("Hit")
	

func _on_animation_player_animation_finished(anim_name):
	sprite.visible = false
