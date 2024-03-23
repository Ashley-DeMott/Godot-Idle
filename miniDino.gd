class_name MiniDino extends Character

@onready var _animated_sprite = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	value = 2
	_animated_sprite.play("walking")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)
	#if linear_velocity != Vector2.ZERO:
	#	_animated_sprite.play("walking")
	#else:
	#	_animated_sprite.play("stand")

func _is_hit(point):
	# A Vector2 with the width and height of the collision box
	var size = $CollisionShape2D.shape.get_size()
	
	# The sides of the colliison box
	var xSide1 = (position.x - size.x)
	var xSide2 = (position.x + size.x)
	var ySide1 = (position.y - size.y)
	var ySide2 = (position.y + size.y)
	
	# If the position is within the bounds of the Enemy's collision box (assumes square centered on sprite)
	return point.x >= xSide1 and point.x <= xSide2 and point.y >= ySide1 and point.y <= ySide2

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
