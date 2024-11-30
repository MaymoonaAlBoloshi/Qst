extends Node2D

const PATH_TO_JSON = "res://data/sample.json"

# UI Nodes
@onready var title_input = $Panel/CenterContainer/VBoxContainer/Title
@onready var details_input = $Panel/CenterContainer/VBoxContainer/Details
@onready var save_button = $Panel/CenterContainer/VBoxContainer/HBoxContainer/Save
@onready var back_button = $Panel/CenterContainer/VBoxContainer/HBoxContainer/Back

func _ready():
	# Setup button signals
	save_button.connect("pressed", Callable(self, "_on_save_pressed"))
	back_button.connect("pressed", Callable(self, "_on_back_pressed"))

func _on_back_pressed():
		get_tree().change_scene_to_file("res://scenes/journal.tscn")

	
func _on_save_pressed():
	# Fetch current date
	var current_date = get_current_date()

	# Collect data from inputs
	var new_entry = {
		"date": current_date,
		"title": title_input.text.strip_edges(),
		"details": details_input.text.strip_edges()
	}

	if new_entry["title"].is_empty() or new_entry["details"].is_empty():
		show_error_popup("Please fill in both the title and details.")
		return

	# Load existing JSON data
	var file = FileAccess.open(PATH_TO_JSON, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var json = JSON.new()
	var parse_result = json.parse_string(content)
	
	# Add new entry to journal_entries
	parse_result.get("journal_entries", []).append(new_entry)

	# Save updated data back to file
	var write_file = FileAccess.open(PATH_TO_JSON, FileAccess.WRITE)
	write_file.store_string(json.stringify(parse_result, "\t"))
	write_file.close()

	# Go back to the main journal scene
	get_tree().change_scene_to_file("res://scenes/journal.tscn")

func get_current_date() -> String:
	var now = Time.get_datetime_dict_from_system()
	return str(now["year"]) + "-" + str(now["month"]).pad_zeros(2) + "-" + str(now["day"]).pad_zeros(2)

func show_error_popup(message: String):
	var popup = Popup.new()
	popup.dialog_text = message
	add_child(popup)
	popup.popup_centered()
