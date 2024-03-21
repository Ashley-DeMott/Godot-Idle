class_name HUD extends CanvasLayer

@export var upgradesList: VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_close_button_pressed():
	$"Upgrades Menu".visible = false

func _on_show_menu_pressed():
	$"Upgrades Menu".visible = true

func _create_buy_panels(upgrades):
	for upgrade in upgrades:
		var upgradePanel = BuyPanel.new()
		upgradePanel._set_text("Name here!")
		upgradePanel._set_button("Price!")		
		upgradesList.add_child(upgradePanel)

func _update_score(score):
	$Score.text = str(score)
