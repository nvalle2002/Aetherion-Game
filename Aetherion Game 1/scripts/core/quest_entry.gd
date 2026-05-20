extends Resource
class_name QuestEntry

enum Classification { STABLE_REALITY, STRUCTURAL_DEVIATION, IDENTITY_CORRUPTION, UNKNOWN_ANOMALY }
enum Confidence { LOW, MEDIUM, HIGH }

@export var id: String = ""
@export var title: String = ""
@export var classification: Classification = Classification.STABLE_REALITY
@export var source: String = ""
@export var description: String = ""
@export var confidence: Confidence = Confidence.LOW
@export var is_complete: bool = false

func to_dict() -> Dictionary:
	return {
		"id": id,
		"title": title,
		"classification": classification,
		"source": source,
		"description": description,
		"confidence": confidence,
		"is_complete": is_complete
	}

func from_dict(dict: Dictionary):
	id = dict.get("id", "")
	title = dict.get("title", "")
	classification = dict.get("classification", 0) as Classification
	source = dict.get("source", "")
	description = dict.get("description", "")
	confidence = dict.get("confidence", 0) as Confidence
	is_complete = dict.get("is_complete", false)
