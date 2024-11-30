extends Node2D

const PATH_TO_JSON = "res://data/sample.json"

# UI Nodes
@onready var title_input = $Panel/CenterContainer/VBoxContainer/Title
@onready var description_input = $Panel/CenterContainer/VBoxContainer/Description
@onready var priority_input = $Panel/CenterContainer/VBoxContainer/Priority
@onready var status_input = $Panel/CenterContainer/VBoxContainer/Status
@onready var save_button = $Panel/CenterContainer/VBoxContainer/HBoxContainer/Save
@onready var back_button = $Panel/CenterContainer/VBoxContainer/HBoxContainer/Back

func _ready():
	# Set up button signals
	save_button.connect("pressed", Callable(self, "_on_save_pressed"))
	back_button.connect("pressed", Callable(self, "_on_back_pressed"))

	# Populate status options
	status_input.add_item("active")
	status_input.add_item("not_started")
	status_input.add_item("completed")

func _on_back_pressed():
	# Navigate back to the main quests scene
	get_tree().change_scene_to_file("res://scenes/quests.tscn")

func _on_save_pressed():
	# Collect data from inputs
	var new_quest = {
		"title": title_input.text.strip_edges(),
		"desc": description_input.text.strip_edges(),
		"priority": priority_input.value,
		"status": status_input.get_item_text(status_input.get_selected_id()),
		"sub_quests": []
	}

	if new_quest["title"].is_empty() or new_quest["desc"].is_empty():
		show_error_popup("Please fill in both the title and description.")
		return

	# Load existing JSON data
	var file = FileAccess.open(PATH_TO_JSON, FileAccess.READ)
	var content = file.get_as_text()
	file.close()


	var json = JSON.new()
	var parse_result = json.parse_string(content)
	
	# Add new entry to journal_entries
	parse_result.get("quests", []).append(new_quest)

	# Save updated data back to file
	var write_file = FileAccess.open(PATH_TO_JSON, FileAccess.WRITE)
	write_file.store_string(json.stringify(parse_result, "\t"))
	write_file.close()

	# Go back to the quests scene
	get_tree().change_scene_to_file("res://scenes/quests.tscn")

func show_error_popup(message: String):
	var popup = Popup.new()
	popup.add_child(Label.new())
	popup.get_child(0).text = message
	add_child(popup)
	popup.popup_centered()
