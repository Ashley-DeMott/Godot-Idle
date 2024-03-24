class_name MiniDino extends Enemy # Class MiniDino inherits functionality from Enemy

# The node for the animated sprite, grabed before running _ready()
@onready var _animated_sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	value = 2
	_animated_sprite.play("walking")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
	# TODO: Add animations
	#if linear_velocity != Vector2.ZERO:
	#	_animated_sprite.play("walking")
	#else:
	#	_animated_sprite.play("stand")
