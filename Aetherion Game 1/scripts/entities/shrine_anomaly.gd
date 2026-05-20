extends StaticBody2D

@export var dialogue_resource: DialogueResource
@onready var interactable = $Interactable

var has_triggered: bool = false

func _ready():
	add_to_group("shrine")
	interactable.interacted.connect(_on_interacted)

func _on_interacted(_player):
	if has_triggered:
		DialogueManager.start_dialogue(dialogue_resource)
		return

	DialogueManager.start_dialogue(dialogue_resource)
	DialogueManager.dialogue_finished.connect(_on_dialogue_finished, CONNECT_ONE_SHOT)

func _on_dialogue_finished():
	has_triggered = true
	
	print("ANOMALY CORE DETECTED: Corrupting Cognitive Log...")
	
	if QuestLog.active_log.has("obs_marcellus_baseline"):
		QuestLog.reclassify_entry("obs_marcellus_baseline", QuestEntry.Classification.UNKNOWN_ANOMALY)
		QuestLog.update_observation_description(
			"obs_marcellus_baseline", 
			"WARNING: Baseline anchor re-indexed. Marcellus's perspective is no longer considered stable reality. Data integrity compromised.",
			QuestEntry.Confidence.LOW
		)
	
	QuestLog.trigger_system_instability()
	
	if not QuestLog.active_log.has("obs_shrine_core"):
		QuestLog.add_observation(
			"obs_shrine_core",
			"The Shrine: Anomaly Source",
			QuestEntry.Classification.UNKNOWN_ANOMALY,
			"The Core",
			"Reality is being re-indexed. The classification system itself is unreliable.",
			QuestEntry.Confidence.LOW
		)
	
	# AUTO-SAVE: Stabilize reality after anomaly encounter
	print("ANOMALY ENCOUNTERED. TRIGGERING EMERGENCY REALITY STABILIZATION...")
	SaveManager.save_game()
