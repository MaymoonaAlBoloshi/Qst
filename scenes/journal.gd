extends Node2D

var journal_entries = []

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
	journal_entries = data.get("journal_entries", [])

	# Populate journal entries
	var container = $Panel/CenterContainer/VBoxContainer/DynamicDataContainer
	for entry in journal_entries:
		container.add_child(create_journal_entry(entry))

	# Back button
	$Panel/CenterContainer/VBoxContainer/HBoxContainer/BackButton.connect("pressed", Callable(self, "_on_back_pressed"))
	
	# New Button
	$Panel/CenterContainer/VBoxContainer/HBoxContainer/New.connect('pressed', Callable(self, "_on_new_pressed" ))

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_new_pressed():
	get_tree().change_scene_to_file("res://scenes/new_journal_entry.tscn")
	
func create_journal_entry(entry_data: Dictionary) -> Control:
	var entry_container = VBoxContainer.new()
	entry_container.add_theme_constant_override("separation", 10)
	entry_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	entry_container.add_theme_stylebox_override("panel", create_card_background())

	# Entry Header (Date and Title)
	var header_container = HBoxContainer.new()
	header_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var date_label = Label.new()
	date_label.text = entry_data.get("date", "Unknown Date")
	date_label.add_theme_color_override("font_color", Color(0.6, 0.6, 0.6))  # Gray for date
	date_label.add_theme_font_size_override("font_size", 16)
	date_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var title_label = Label.new()
	title_label.text = entry_data.get("title", "Untitled Entry")
	title_label.add_theme_font_size_override("font_size", 20)
	title_label.add_theme_color_override("font_color", Color(0.8, 0.2, 0.2))  # Reddish accent
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	header_container.add_child(date_label)
	header_container.add_child(title_label)
	entry_container.add_child(header_container)

	# Entry Details (Truncated with Read More Button)
	var details_container = HBoxContainer.new()
	details_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var details_label = Label.new()
	details_label.text = entry_data.get("details", "No details provided.")
	details_label.add_theme_font_size_override("font_size", 14)
	details_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	details_label.clip_text = true  # Enable text clipping for truncation

	var read_more_button = Button.new()
	read_more_button.text = "Read More"
	read_more_button.connect("pressed", Callable(self, "_on_read_more_pressed").bind(entry_data))
	read_more_button.size_flags_horizontal = Control.SIZE_FILL

	details_container.add_child(details_label)
	details_container.add_child(read_more_button)
	entry_container.add_child(details_container)

	return entry_container

func _on_read_more_pressed(entry_data: Dictionary):
	# Example action for Read More button
	print("Read more about:", entry_data)

func create_card_background() -> StyleBoxFlat:
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0.2, 0.2, 0.2, 0.9)  # Slightly darker for journal entries
	stylebox.border_color = Color(0.3, 0.3, 0.3, 1)
	return stylebox
