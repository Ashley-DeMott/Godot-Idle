class_name Item extends RigidBody2D

# TODO: Turn into abstract class, with Coin/Pickup using this code
# Pickup - interactions with Player, has a value (num of pickup), Coin - value goes toward Player's coin stat

static var screen_size # Size of game window
var points = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	# TODO: Make into singleton? But what about resizing?
	screen_size = get_viewport_rect().size # Get the current screen size
	
	points += randi() % 9 # Random point value between 1 and 11

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	# TODO: Still moving, didn't freeze it?
	# 		Could create a different spawning script that doesn't add velocity
	position += Vector2.ZERO * delta
	
	# If the points have been reassigned
	if points == 0:
		queue_free() # delete object

func _get_points():
	return points
	
func _player_hit():
	points = 0 # points were taken by the Player
	$CollisionShape2D.set_deferred("disabled", true) # Can no longer collide
