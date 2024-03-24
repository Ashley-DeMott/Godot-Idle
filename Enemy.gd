class_name Enemy extends Character # Abstract class Enemy inherits functionality from Character

# Called when the node enters the scene tree for the first time.
func _ready():
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	super(delta)

func _is_hit(point):
	""" Determines if the given point (Vector2) is within the object's collisionShape (assumes square)"""
	# A Vector2 with the width and height of the collision box
	var size = $CollisionShape2D.shape.get_size()
	
	# The sides of the colliison box
	var xSide1 = (position.x - (size.x / 2.0))
	var xSide2 = (position.x + (size.x / 2.0))
	var ySide1 = (position.y - (size.y / 2.0))
	var ySide2 = (position.y + (size.y / 2.0))
	
	# If the position is within the bounds of the Enemy's collision box (assumes square centered on sprite)
	return point.x >= xSide1 and point.x <= xSide2 and point.y >= ySide1 and point.y <= ySide2
