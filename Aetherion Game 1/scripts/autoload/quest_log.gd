extends Node

signal log_updated(entry: QuestEntry)
signal reality_fractured

var active_log: Dictionary = {} # String ID -> QuestEntry
var is_unstable: bool = false

func add_observation(id: String, title: String, type: QuestEntry.Classification, source: String, desc: String, conf: QuestEntry.Confidence):
	if active_log.has(id):
		return
		
	var entry = QuestEntry.new()
	entry.id = id
	entry.title = title
	entry.classification = type
	entry.source = source
	entry.description = desc
	entry.confidence = conf
	
	active_log[id] = entry
	log_updated.emit(entry)
	print("New Anomaly Recorded: ", title, " [", type, "]")

func update_observation_description(id: String, new_desc: String, new_conf: QuestEntry.Confidence = -1):
	if active_log.has(id):
		active_log[id].description = new_desc
		if new_conf != -1:
			active_log[id].confidence = new_conf
		log_updated.emit(active_log[id])

func reclassify_entry(id: String, new_type: QuestEntry.Classification):
	if active_log.has(id):
		active_log[id].classification = new_type
		log_updated.emit(active_log[id])

func trigger_system_instability():
	is_unstable = true
	reality_fractured.emit()
	for entry in active_log.values():
		entry.confidence = QuestEntry.Confidence.LOW
		log_updated.emit(entry)

func get_entries_by_classification(type: QuestEntry.Classification) -> Array[QuestEntry]:
	var result: Array[QuestEntry] = []
	for entry in active_log.values():
		if entry.classification == type:
			result.append(entry)
	return result

func get_state() -> Dictionary:
	var entries = {}
	for id in active_log:
		entries[id] = active_log[id].to_dict()
	return {
		"is_unstable": is_unstable,
		"entries": entries
	}

func load_state(state: Dictionary):
	is_unstable = state.get("is_unstable", false)
	var entries_dict = state.get("entries", {})
	active_log.clear()
	for id in entries_dict:
		var entry = QuestEntry.new()
		entry.from_dict(entries_dict[id])
		active_log[id] = entry
		log_updated.emit(entry)
