class_name BuyPanel extends Control

var buyName
var price
var button

# Called when the node enters the scene tree for the first time.
func _ready():
	buyName = $Label
	button = $Button

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_text(t):
	buyName.text = t

func _set_button(price):
	button.text = price
