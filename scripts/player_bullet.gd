extends Area2D

@export var speed: float = 400.0
@export var max_distance: float = 500.0

var direction: Vector2 = Vector2.RIGHT
var start_position: Vector2

func _ready():
	start_position = global_position
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	position += direction * speed * delta

	if global_position.distance_to(start_position) > max_distance:
		queue_free()

func _on_body_entered(body: Node):
	if body.is_in_group("enemies") and body.has_method("take_damage"):
		body.take_damage(1)
		queue_free()
