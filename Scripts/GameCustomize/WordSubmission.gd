extends LineEdit




func _on_text_submitted(new_text: String) -> void:
	print("[TEXT SUBMITTED] Text: %s" % new_text)


func _on_text_changed(new_text: String) -> void:
	print("[TEXT CHANGED] New Text: %s" % new_text)
	
	if(new_text.length() <= GlobalVariables.wordChoice.length()):
		$"..".ChangeText(new_text)
	else:
		pass #replace with animation later
