extends CanvasLayer
class_name PlayerUI

@export_category("Data Resources")
@export var player : Player
@export var inventory : InventoryManager

@export_category("Children")
@export var HealthBar : ProgressBar
@export var AttackIndicatorBox : IndicatorBox
@export var StaminaIndicatorBox : IndicatorBox
@export var AnxMeter : Label
@export var CoinLabel : Label
@export var PowderGUI : ItemGUI
@export var ElixirGUI : ItemGUI
@export var StatueMenu : Statue_Menu
@export var Shop : ShopMenu
#var iniinv : InventoryItem

func _ready():
	player = get_parent()
	HealthBar.max_value = player.MaxHealth

func _process(_delta):
	HealthBar.value = player.CurrentHealth
	CoinLabel.text = ("$" + str(inventory.Coins))	
	#print("ths is iniinv " + str(iniinv.Name))
		
	if inventory.Elixirs > 0:
		
		if (inventory.inventoyMap[InventoryItem.eItemTypes.Elixir]["Lite Elixir"]).AmountHeld > 0:
			ElixirGUI.DisplayItem(inventory.inventoyMap[InventoryItem.eItemTypes.Elixir]["Lite Elixir"])
		else:
			ElixirGUI.DisplayItem(inventory.inventoyMap[InventoryItem.eItemTypes.Elixir]["Mild Elixir"])
	else:
		ElixirGUI.visible = false
		
	if inventory.Powders > 0:
		PowderGUI.DisplayItem(inventory.inventoyMap[InventoryItem.eItemTypes.Powder]["Azalea Powder"])
	else:
		PowderGUI.visible = false
	#
	if inventory.CurrentItem != null:
		match inventory.CurrentItem.ItemType:
			InventoryItem.eItemTypes.Elixir:
				ElixirGUI.Border.visible = true
				PowderGUI.Border.visible = false
		
			InventoryItem.eItemTypes.Powder:
				PowderGUI.Border.visible = true
				ElixirGUI.Border.visible = false
	#
	var eTimeInMinutes = player.GM.ElapsedTime / 60
	var eTimeSeconds = fmod(player.GM.ElapsedTime, 60)
	AnxMeter.text = "Elapsed Time: " + "%02d:%02d" % [eTimeInMinutes, eTimeSeconds]
	
	if GameSettings.ShouldFillAnxiety == true:
		$"Main UI/AnxietyMeter".visible = true
	else:
		$"Main UI/AnxietyMeter".visible = false
	
func UpdateAttackIcons(Amount : int):
	for i in AttackIndicatorBox.get_child_count():
		AttackIndicatorBox.get_child(i).queue_free()
	
	for i in Amount:
		var newIcon = AttackIndicatorBox.Icon.instantiate()
		AttackIndicatorBox.add_child(newIcon)
		
func SetStaminaIcons(Amount : int):
	for i in StaminaIndicatorBox.get_child_count():
		StaminaIndicatorBox.get_child(i).queue_free()
	
	for i in Amount:
		var newIcon = StaminaIndicatorBox.Icon.instantiate()
		StaminaIndicatorBox.add_child(newIcon)

func UpdateStaminaIcons(Amount : int):
	var icons = StaminaIndicatorBox.get_children()
	
	for i in icons.size():
		if i > Amount - 1:
			icons[i].IsFilled = false
			
func RefillStaminaIcons(Amount : int):
	for i in Amount:
		if StaminaIndicatorBox.get_child(i).IsFilled == false:
			StaminaIndicatorBox.get_child(i).IsFilled = true

func ToggleMenu(Menu : Object, Choice : bool):
	Menu.visible = Choice
	if Choice == true:
		player.CurrentState = player.eStates.InMenu
	else:
		player.CurrentState = player.eStates.NoAction
