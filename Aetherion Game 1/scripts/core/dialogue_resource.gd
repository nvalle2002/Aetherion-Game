extends Resource
class_name DialogueResource

@export var dialogue_data: Array[Dictionary] = [
	{"speaker": "Narrator", "text": "Hello world!"}
]

# Optional quest-related fields
@export var quest_id: String = ""
@export var quest_title: String = ""
@export var quest_type: QuestEntry.Classification = QuestEntry.Classification.STABLE_REALITY
@export var quest_description: String = ""
@export var quest_confidence: QuestEntry.Confidence = QuestEntry.Confidence.LOW
