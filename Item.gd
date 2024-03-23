class_name Item extends RigidBody2D

# TODO: Turn into abstract class, with Coin/Pickup using this code
# Pickup - interactions with Player, has a value (num of pickup), Coin - value goes toward Player's coin stat

static var screen_size # Size of game window
@export var points = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: Make a singleton to delete off-screen items? But what about window resizing?
	#screen_size = get_viewport_rect().size # Get the current screen size
	
	points += randi() % 9 # Random point value between 1 and 11

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
	# If the points have been reassigned
	#if points == 0:
	#	queue_free() # delete object
	pass
	
func _get_points():
	return points
	
func _player_hit():
	""" If the Player hits this object """
	points = 0 # points are taken by the Player
	$CollisionShape2D.set_deferred("disabled", true) # Can no longer collide
	queue_free()
