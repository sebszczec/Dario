extends Node2D

@onready var sprite = $Sprite2D

func changeState(enabled):
	sprite.visible = enabled
