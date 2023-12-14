extends Node2D

var dotScene = preload("res://dot.tscn")
var center = Vector2(0, 0)
const HALF_OF_LENGHT = 20
var dots = []
var nextIndex = [1, 2, 3, 0]
const K = 10
const P = 100000

# Called when the node enters the scene tree for the first time.
func _ready():
	center = global_position
	
	for i in 4:
		var dot : CharacterBody2D = dotScene.instantiate()
		dots.append(dot)
	
	dots[0].position.x = -HALF_OF_LENGHT
	dots[0].position.y = -HALF_OF_LENGHT
	
	dots[1].position.x = -HALF_OF_LENGHT
	dots[1].position.y = HALF_OF_LENGHT
	
	dots[2].position.x = HALF_OF_LENGHT
	dots[2].position.y = HALF_OF_LENGHT
	
	dots[3].position.x = HALF_OF_LENGHT
	dots[3].position.y = -HALF_OF_LENGHT
	
	for i in 4:
		add_child(dots[i])
	

func  _physics_process(delta):
	# Clear forces
	for i in 4:
		dots[i].force = Vector2(0, 0)
	
	# Calculate normals
	for i in 4:
		dots[i].normal = dots[i].position.normalized()
	
	# Calculate volume
	var volume = 0
	for i in 4:
		var currentDot = dots[i]
		var nextDot = dots[nextIndex[i]]
		var distance = currentDot.position.distance_to(nextDot.position)
	
		volume += 0.5 * abs(currentDot.position.x - nextDot.position.x) * abs(currentDot.normal.x) * distance
		
	#print("Volume: %f" % volume)
		
		
	# Calulate presure
	var uVolume = 1.0 / volume
	for i in 4:
		var currentDot = dots[i]
		var nextDot = dots[nextIndex[i]]
		var distance = currentDot.position.distance_to(nextDot.position)
		
		var presure = uVolume * P * distance
		
		var force = currentDot.normal * presure
		currentDot.force += force
	
	# Calculate sprint force
	for i in 4:
		var currentDot = dots[i]
		var nextDot = dots[nextIndex[i]]
		
		var force : Vector2 = K * (nextDot.position - currentDot.position)	
		currentDot.force += force
		nextDot.force -= force
	
	
