extends CharacterBody2D

var direction = Vector2(-2, 1)
var speed = 200

func _physics_process(delta):
	velocity = direction * speed
	
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "TileMap":
			self.position.x = 300
			self.position.y = 256

