class_name Item extends RigidBody2D
signal hit

@export var value = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
	pass
	
func _get_value():
	""" Return the value of the Item """
	return value
	
func _set_value(val):
	""" Assign the value of the Item """
	value = val

func _on_body_entered(body):
	""" Called when the Player collides with this Item """
	hide() # Item disappears after being hit.
	hit.emit() # Tell main that the Player has collided
	
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true)

func _on_visible_on_screen_notifier_2d_screen_exited():
	""" If the Item is no longer visible on screen """
	queue_free() # Delete the Item

func _delete():
	""" Called to remove the Item """
	queue_free() # Delete the Item
