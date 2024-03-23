class_name MiniDino extends Character

@onready var _animated_sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	points = 2
	_animated_sprite.play("walking")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
	#if linear_velocity != Vector2.ZERO:
	#	_animated_sprite.play("walking")
	#else:
	#	_animated_sprite.play("stand")

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
