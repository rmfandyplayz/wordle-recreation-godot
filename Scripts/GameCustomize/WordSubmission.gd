extends LineEdit




func _on_text_submitted(new_text: String) -> void:
	print("[TEXT SUBMITTED] Text: %s" % new_text)


func _on_text_changed(new_text: String) -> void:
	print("[TEXT CHANGED] New Text: %s" % new_text)
	
	$"..".ChangeText(new_text)
