extends Node

signal dialogue_started
signal dialogue_finished

var is_active: bool = false
var current_dialogue: DialogueResource
var current_page: int = 0
var ui_ref: Control = null

func update_ui_ref(ui):
	ui_ref = ui

func start_dialogue(resource: DialogueResource) -> void:
	if is_active:
		return
	
	current_dialogue = resource
	current_page = 0
	is_active = true
	dialogue_started.emit()
	show_current_page()
	
	# Trigger quest entry if resource has quest data
	if current_dialogue.quest_id != "":
		QuestLog.add_observation(
			current_dialogue.quest_id,
			current_dialogue.quest_title,
			current_dialogue.quest_type,
			current_dialogue.dialogue_data[0].get("speaker", "Unknown"),
			current_dialogue.quest_description,
			current_dialogue.quest_confidence
		)

func next_page() -> void:
	current_page += 1
	if current_page >= current_dialogue.dialogue_data.size():
		finish_dialogue()
	else:
		show_current_page()

func show_current_page():
	var page = current_dialogue.dialogue_data[current_page]
	if ui_ref:
		ui_ref.display_page(page.get("speaker", "???"), page.get("text", "..."))

func finish_dialogue() -> void:
	is_active = false
	if ui_ref:
		ui_ref.close()
	dialogue_finished.emit()
