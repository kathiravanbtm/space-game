extends CharacterBody2D

@export var speed: float = 30.0
@export var patrol_distance: float = 100.0

var direction := -1
var start_position: Vector2

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	start_position = global_position

func _physics_process(delta):
	var distance_from_start = global_position.x - start_position.x

	# Flip direction if reached patrol limit
	if abs(distance_from_start) >= patrol_distance:
		direction *= -1
		animated_sprite.flip_h = direction > 0

	# Assign horizontal velocity
	velocity.x = direction * speed

	# Apply movement (Godot 4 uses the built-in velocity)
	move_and_slide()

	# Play animation
	if abs(velocity.x) > 0:
		animated_sprite.play("walk")
	else:
		animated_sprite.play("idle")

func take_damage(amount: int) -> void:
	queue_free() # This will remove (kill) the enemy instantly
