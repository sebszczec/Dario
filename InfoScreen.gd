extends Node2D

@onready var lifeValue = $CanvasLayer/LifeValue
@onready var refreshTimer = $CanvasLayer/RefreshTimer
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	lifeValue.text = "Initiating"
	player = get_parent().get_node("Player")
	refreshTimer.start()


func _on_refresh_timer_timeout():
	lifeValue.text = str(player.Life)
