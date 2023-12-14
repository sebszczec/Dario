extends CharacterBody2D


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


var force = Vector2(0, 0)
var normal = Vector2(0, 0)

func _physics_process(delta):
	velocity = force * delta

	move_and_slide()
