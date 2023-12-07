extends Node2D

@onready var lifeValue = $CanvasLayer/LifeValue

# Called when the node enters the scene tree for the first time.
func _ready():
	lifeValue.text = "-200"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
