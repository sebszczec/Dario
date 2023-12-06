extends Node2D

@export_category("Parameters")
@export_range(1, 500) var Length : int = 100
@export_range(1, 100) var NumberOfParticles : int = 20

@onready var smoke1 = $Smoke1
@onready var smoke2 = $Smoke2

# Called when the node enters the scene tree for the first time.
func _ready():
	smoke1.process_material.set("emission_box_extents", Vector3(Length, 1, 1))
	smoke2.process_material.set("emission_box_extents", Vector3(Length, 1, 1))
	
	smoke1.amount = NumberOfParticles
	smoke2.amount = NumberOfParticles
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
