class_name HUD extends CanvasLayer

# Signals that allow functions from main to be called
signal endGame
signal startGame

# Get specific nodes in the HUD
@export var upgradesList: VBoxContainer
@export var buyUpgrade: PackedScene
@export var numCoins : Label
@export var HPBar : ColorRect
@export var HP : ColorRect
@export var numHP : Label

# Called when the node enters the scene tree for the first time.
func _ready():
	#HP = HPBar.get_node("ColorRect")
	#numHP = HPBar.get_node("Label")
	pass
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_close_button_pressed():
	""" Hide the upgrades menu """
	$"Upgrades Menu".visible = false
func _on_show_menu_pressed():
	""" Showt the upgrades menu """
	$"Upgrades Menu".visible = true

func _create_buy_panels(upgrades):
	"""Creates a buy panel for each upgrade available"""
	for upgrade in upgrades:
		var upgradePanel = buyUpgrade.instantiate()
		upgradePanel._set_text(upgrade["name"], upgrade["price"])
		upgradesList.add_child(upgradePanel)

func _update_coins(coins):
	""" Update the displayed coins """
	numCoins.text = str(coins)
	
func _update_health(currentHP, maxHP):
	""" Update the HP bar """
	numHP.text = str(currentHP) + " / " + str(maxHP)
	
	# TODO: Set HP's width to ratio of current ot maxHP
	# width of HP is HPBar's width * current/maxHP
	var scale = float(currentHP) / float(maxHP)
	if scale < 1:
		HP.set_size(Vector2(HPBar.get_size().x * scale, HPBar.get_size().y))

func _toggle_game_over():
	""" Toggle the visibility of the 'Game Over' window """
	$GameOver.visible = !$GameOver.visible

func _on_continue_pressed():
	""" Emit a 'startGame' signal that main recieves """
	startGame.emit()

func _on_quit_pressed():
	""" Emit an 'endGame' signal that main recieves """
	endGame.emit()
