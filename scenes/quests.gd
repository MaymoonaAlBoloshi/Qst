extends Node2D

var quests_data = []

const PATH_TO_JSON = "res://data/sample.json"

func readJSON(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish

func _ready():
	# Load JSON
	var data = readJSON(PATH_TO_JSON)
	quests_data = data.get("quests", [])

	# Populate quests
	var container = $Panel/CenterContainer/VBoxContainer/VBoxContainer
	for quest in quests_data:
		container.add_child(create_quest_entry(quest))

	# Back button
	$Panel/CenterContainer/VBoxContainer/HBoxContainer/BackButton.connect("pressed", Callable(self, "_on_back_pressed"))

	# New Quest button
	$Panel/CenterContainer/VBoxContainer/HBoxContainer/AddNewQuest.connect("pressed", Callable(self, "_on_new_pressed"))

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_new_pressed():
	get_tree().change_scene_to_file("res://scenes/add_quest.tscn")

func create_quest_entry(quest_data: Dictionary) -> Control:
	var quest_container = VBoxContainer.new()
	quest_container.add_theme_constant_override("separation", 10)
	quest_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	quest_container.add_theme_stylebox_override("panel", create_card_background())
	quest_container.add_theme_color_override("font_color", Color(0.3, 0.3, 0.3)) # Darker font color for general text

	# Title and Status
	var header_container = HBoxContainer.new()
	header_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var title_label = Label.new()
	title_label.text = quest_data.get("title", "Unknown Quest")
	title_label.add_theme_font_size_override("font_size", 18)
	title_label.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1)) # Darker title color
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var status_label = Label.new()
	status_label.text = quest_data.get("status", "Unknown Status").capitalize()
	status_label.add_theme_color_override("font_color", get_status_color(quest_data.get("status", "")))
	status_label.add_theme_font_size_override("font_size", 14)

	header_container.add_child(title_label)
	header_container.add_child(status_label)
	quest_container.add_child(header_container)

	# Priority
	var priority_container = HBoxContainer.new()
	var priority_label = Label.new()
	priority_label.text = "Priority: "
	priority_label.add_theme_font_size_override("font_size", 14)
	priority_label.add_theme_color_override("font_color", Color(0.2, 0.2, 0.2)) # Slightly lighter than title

	var priority_value = Label.new()
	priority_value.text = str(quest_data.get("priority", "N/A"))
	priority_value.add_theme_color_override("font_color", get_priority_color(quest_data.get("priority", 0)))
	priority_value.add_theme_font_size_override("font_size", 14)

	priority_container.add_child(priority_label)
	priority_container.add_child(priority_value)
	quest_container.add_child(priority_container)

	# Description
	var desc_label = Label.new()
	desc_label.text = quest_data.get("desc", "No description available.")
	desc_label.add_theme_font_size_override("font_size", 12)
	desc_label.add_theme_color_override("font_color", Color(0.3, 0.3, 0.3)) # Darker general font
	desc_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	quest_container.add_child(desc_label)

	# Sub-quests
	if quest_data.get("sub_quests", []):
		var sub_quests_container = VBoxContainer.new()
		sub_quests_container.add_theme_constant_override("separation", 5)

		var sub_quests_title = Label.new()
		sub_quests_title.text = "Sub-Quests:"
		sub_quests_title.add_theme_font_size_override("font_size", 14)
		sub_quests_title.add_theme_color_override("font_color", Color(0.15, 0.15, 0.15)) # Distinct darker color for sub-quest header
		sub_quests_container.add_child(sub_quests_title)

		for sub_quest in quest_data.get("sub_quests", []):
			var sub_quest_label = Label.new()
			sub_quest_label.text = "- " + sub_quest.get("title", "Unknown Sub-Quest") + " [" + sub_quest.get("status", "Unknown") + "]"
			sub_quest_label.add_theme_font_size_override("font_size", 12)
			sub_quest_label.add_theme_color_override("font_color", Color(0.2, 0.4, 0.6)) # Separate blueish color for sub-quests
			sub_quests_container.add_child(sub_quest_label)

		quest_container.add_child(sub_quests_container)

	return quest_container

func get_status_color(status: String) -> Color:
	match status.to_lower():
		"completed":
			return Color(0, 1, 0) # Green
		"active":
			return Color(1, 0.65, 0) # Orange
		"pending":
			return Color(0.6, 0.6, 0.6) # Gray
		"not_started":
			return Color(1, 0, 0) # Red
		_:
			return Color(1, 1, 1) # White

func get_priority_color(priority: int) -> Color:
	match priority:
		1:
			return Color(1, 0, 0) # Red
		2:
			return Color(1, 0.65, 0) # Orange
		3:
			return Color(1, 1, 0) # Yellow
		_:
			return Color(0.6, 0.6, 0.6) # Gray

func create_card_background() -> StyleBoxFlat:
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.1, 0.1, 0.1, 0.5)
	stylebox.border_color = Color(0.2, 0.2, 0.2, 0.8)
	stylebox.border_width_bottom = 4
	stylebox.border_color = Color.WEB_GRAY
	return stylebox
