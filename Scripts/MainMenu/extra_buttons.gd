extends Node



func _on_github_pressed() -> void:
	get_node("../MainMenuSfx/UrlClick").play()
	OS.shell_open("https://github.com/rmfandyplayz/wordle-recreation-godot")
