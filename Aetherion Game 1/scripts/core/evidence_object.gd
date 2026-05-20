extends Interactable
class_name EvidenceObject

@export_group("Evidence Data")
@export var evidence_id: String = ""
@export var evidence_title: String = ""
@export var classification: QuestEntry.Classification = QuestEntry.Classification.STABLE_REALITY
@export var confidence: QuestEntry.Confidence = QuestEntry.Confidence.MEDIUM

@export_group("Narrative")
@export var initial_dialogue: DialogueResource
@export var post_shrine_dialogue: DialogueResource # Dialogue that changes after anomaly

var has_been_inspected: bool = false

func interact(player: CharacterBody2D) -> void:
	has_been_inspected = true
	
	var active_dialogue = initial_dialogue
	if QuestLog.is_unstable and post_shrine_dialogue:
		active_dialogue = post_shrine_dialogue
	
	if active_dialogue:
		# Temporarily inject quest data into dialogue if not set
		if active_dialogue.quest_id == "":
			active_dialogue.quest_id = evidence_id
			active_dialogue.quest_title = evidence_title
			active_dialogue.quest_type = classification
			active_dialogue.quest_description = active_dialogue.dialogue_data[0].text
			active_dialogue.quest_confidence = confidence
		
		DialogueManager.start_dialogue(active_dialogue)
	
	super.interact(player)
