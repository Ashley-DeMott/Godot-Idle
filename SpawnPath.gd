extends Path2D

@export var speed = 100
@export var max_speed = 1000
@export var random : bool
@onready var path_follow : PathFollow2D = $Location

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if random:
		speed = randf_range(speed, max_speed)
	path_follow.progress += speed * delta
