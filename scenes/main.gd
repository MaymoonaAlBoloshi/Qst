extends Node2D

const QUEST_SCENE = "res://scenes/quests.tscn"
const JOURNAL_SCENE = "res://scenes/journal.tscn"

func _on_quest_button_pressed():
	get_tree().change_scene_to_file(QUEST_SCENE)

func _on_journal_button_pressed():
	get_tree().change_scene_to_file(JOURNAL_SCENE)

func _ready():
	$Panel/CenterContainer/GridContainer/QuestBtn.text = "Quests"
	$Panel/CenterContainer/GridContainer/QuestBtn.connect("pressed", Callable(self, "_on_quest_button_pressed"))

	$Panel/CenterContainer/GridContainer/JournalBtn.text = "Journal"
	$Panel/CenterContainer/GridContainer/JournalBtn.connect("pressed", Callable(self, "_on_journal_button_pressed"))
