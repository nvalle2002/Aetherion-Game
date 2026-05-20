extends Control

@onready var entry_list = %EntryList
@onready var detail_panel = %DetailPanel
@onready var title_label = %EntryTitle
@onready var class_label = %EntryClassification
@onready var conf_label = %EntryConfidence
@onready var source_label = %EntrySource
@onready var desc_label = %EntryDescription
@onready var status_label = %StatusLabel

var selected_id: String = ""
var drift_timer: float = 0.0

func _ready():
	visible = false
	QuestLog.log_updated.connect(_on_log_updated)
	refresh_list()

func _input(event):
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_menu"): # Assuming a menu key
		toggle_visibility()

func toggle_visibility():
	visible = !visible
	if visible:
		refresh_list()
		update_status_display()

func refresh_list():
	# Clear existing list
	for child in entry_list.get_children():
		child.queue_free()
	
	for entry_id in QuestLog.active_log:
		var entry = QuestLog.active_log[entry_id]
		var btn = Button.new()
		btn.text = entry.title
		btn.pressed.connect(_on_entry_selected.bind(entry_id))
		entry_list.add_child(btn)

func _on_entry_selected(id: String):
	selected_id = id
	update_detail_view()

func _on_log_updated(_entry):
	if visible:
		refresh_list()
		if selected_id == _entry.id:
			update_detail_view()
		update_status_display()

func update_status_display():
	if QuestLog.is_unstable:
		status_label.text = "RECONSTRUCTION STATUS: CORRUPTED"
		status_label.modulate = Color(1, 0.2, 0.2)
	elif QuestLog.active_log.size() > 0:
		status_label.text = "RECONSTRUCTION STATUS: DEGRADED"
		status_label.modulate = Color(0.8, 0.8, 0.4)
	else:
		status_label.text = "RECONSTRUCTION STATUS: STABLE"
		status_label.modulate = Color(0.4, 0.8, 0.4)

func update_detail_view():
	if not QuestLog.active_log.has(selected_id):
		return
	
	var entry = QuestLog.active_log[selected_id]
	title_label.text = entry.title
	class_label.text = "CLASSIFICATION: " + get_class_string(entry.classification)
	conf_label.text = "CONFIDENCE: " + get_conf_string(entry.confidence)
	source_label.text = "SOURCE: " + entry.source
	desc_label.text = entry.description
	
	# Confidence-based visual weight
	match entry.confidence:
		QuestEntry.Confidence.HIGH:
			detail_panel.modulate = Color(1, 1, 1, 1)
			desc_label.add_theme_constant_override("outline_size", 0)
		QuestEntry.Confidence.MEDIUM:
			detail_panel.modulate = Color(0.8, 0.8, 0.9, 0.9)
		QuestEntry.Confidence.LOW:
			detail_panel.modulate = Color(0.7, 0.5, 0.5, 0.8)

func get_class_string(type):
	match type:
		QuestEntry.Classification.STABLE_REALITY: return "STABLE REALITY"
		QuestEntry.Classification.STRUCTURAL_DEVIATION: return "STRUCTURAL DEVIATION"
		QuestEntry.Classification.IDENTITY_CORRUPTION: return "IDENTITY CORRUPTION"
		QuestEntry.Classification.UNKNOWN_ANOMALY: return "UNKNOWN ANOMALY"
	return "???"

func get_conf_string(conf):
	match conf:
		QuestEntry.Confidence.LOW: return "LOW"
		QuestEntry.Confidence.MEDIUM: return "MEDIUM"
		QuestEntry.Confidence.HIGH: return "HIGH"
	return "???"

func _process(delta):
	if not visible: return
	
	# Reality Drift Effect
	drift_timer += delta
	if drift_timer > 0.1 and QuestLog.is_unstable:
		drift_timer = 0
		if randf() < 0.05: # Subtle flicker
			desc_label.position.x = randf_range(-1, 1)
			desc_label.position.y = randf_range(-1, 1)
		if randf() < 0.02: # Classification flicker
			var temp_class = randi() % 4
			class_label.text = "CLASSIFICATION: " + get_class_string(temp_class)
		else:
			if selected_id != "":
				var entry = QuestLog.active_log[selected_id]
				class_label.text = "CLASSIFICATION: " + get_class_string(entry.classification)
