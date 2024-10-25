extends Node

#does the animation thingy for the welcome screen and fades it out

@onready var backgroundColor : ColorRect = $"Background Color"
@onready var text : RichTextLabel = $"Background Color/Welcome Text"
@onready var textAfterImage : RichTextLabel = $"Background Color/Welcome Text Afterimage"

func _ready() -> void:
	if GlobalVariables.seenWelcomeScreen == false:
		backgroundColor.visible = true
		await get_tree().create_timer(0.5).timeout
		text.visible = true
		get_node("../MainMenuSfx/UtEntranceSound").play()
		create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).tween_property(text, "scale", Vector2.ONE, 0.3)
		await get_tree().create_timer(0.2).timeout
		textAfterImage.visible = true
		create_tween().tween_property(textAfterImage, "scale", Vector2(1.5, 1.5), 1)
		create_tween().tween_property(textAfterImage, "self_modulate", Color.TRANSPARENT, 1)
		await get_tree().create_timer(1).timeout
		create_tween().tween_property(backgroundColor, "self_modulate", Color.TRANSPARENT, .5)
		create_tween().tween_property(text, "self_modulate", Color.TRANSPARENT, .5)
		await get_tree().create_timer(.5).timeout
		
		backgroundColor.visible = false
		text.visible = false
		textAfterImage.visible = false
		GlobalVariables.seenWelcomeScreen = true
