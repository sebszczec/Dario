extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = Vector2(0, 1000)


var force = Vector2(0, 0)
var normal = Vector2(0, 0)

func _physics_process(delta):
	velocity = (gravity + force) * delta
	#velocity = force * delta

	move_and_slide()
