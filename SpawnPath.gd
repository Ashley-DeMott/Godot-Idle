extends Path2D

# The follower on the Path
@onready var path_follow : PathFollow2D = $Location

# The speed and max speed of the Path follower
@export var speed = 100
@export var max_speed = 1000

# If the speed should be randomized
@export var random_speed : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	""" Called every frame, where 'delta' is the time since the previous frame """
	if random_speed:
		speed = randf_range(speed, max_speed)
	
	# Move the path follower along the path
	path_follow.progress += speed * delta
