extends Node

@export var hud: HUD
@export var player: Player
@export var enemy_scene: PackedScene
@export var item_scene: PackedScene

# Max enemies and items that can be spawned
var maxEnemies = 5
var maxPickups = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	var upgrades = [{"name": "one", "price": 10, "num": 1}, {"name": "two", "price": 15, "num": 0}]
	
	$EnemyTimer.start()
	$ItemTimer.start()
	#hud._create_buy_panels(upgrades)
	
	# Create upgrades in the game place
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	hud._update_score(player._get_points())
	pass

func _spawn_item_on_path(scene, path):
	var item = scene.instantiate()
	
	var node = "" + path + "/Location"
	
	# Get the location from the path
	var spawn_location = get_node(node)
	
	# Set the item's direction perpendicular to the path direction.
	var direction = spawn_location.rotation + PI / 2

	# Set the item's position to a random location.
	item.position = spawn_location.position

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	item.rotation = direction

	# Choose the velocity for the item.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	item.linear_velocity = velocity.rotated(direction)

	# Spawn the item by adding it to the Main scene.
	add_child(item)

func _spawn_enemy():
	#var enemy_spawn = $EnemySpawnPath/Location
	_spawn_item_on_path(enemy_scene, "EnemySpawnPath")	
	
func _spawn_pickup():
	#var item = item_scene.instantiate()	
	#var item_spawn = $ItemSpawnPath/ItemSpawnLocation
	_spawn_item_on_path(item_scene, "ItemSpawnPath")
