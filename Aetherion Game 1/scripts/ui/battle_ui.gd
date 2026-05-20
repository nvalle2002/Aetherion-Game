extends Control

signal command_selected(action)

@onready var action_menu = %ActionMenu
@onready var text_feed = %TextFeed
@onready var enemy_info = %EnemyInfo

func display_turn():
	action_menu.visible = true

func log_text(text: String):
	text_feed.text = text

func update_enemy_display(data: EnemyData):
	enemy_info.text = data.enemy_name + "\nHealth: " + str(data.base_health)

func _on_action_pressed(action):
	command_selected.emit(action)
	action_menu.visible = false
