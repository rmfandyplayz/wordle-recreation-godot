extends Button

#this script handles the animation for:
#- hover over the play button
#- un-hovering the play button
#- pressing the play button

#buttons that don't mention "which button" are assumed to be the button this script is attached to (play button)
@export var tweenDuration : float
@export var pressedTweenDuration : float
@export var buttonHoverSizeModifier : float
@onready var originalButtonSize : Vector2 = size

@onready var settingsButton : Button = $"../Settings"
@onready var settingsButtonPos : Vector2 = settingsButton.position

@onready var jumpscareButton : Button = $"../Mr Kinney Jumpscare"
@onready var jumpscareButtonPos : Vector2 = jumpscareButton.position

var isPlayButtonActive : bool = false #if the play button is pressed and in the play menu, don't allow the mouse enter and exit things happen




func _on_pressed() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	isPlayButtonActive = true
	
	tween.tween_property(self, "scale", Vector2.ONE, pressedTweenDuration)
	tween.tween_property(self, "scale", Vector2.ONE * buttonHoverSizeModifier, tweenDuration)
	
	await tween.finished
	$"../Settings".disabled = true
	$"../Mr Kinney Jumpscare".disabled = true
	
	#animation for the buttons under the play submenu goes under here
	#note: the size for the buttons post-play should be 156 pixels in height.
	
	#fade out the text and icon
	#continue here
	
	

func _on_mouse_entered() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	if isPlayButtonActive == false:
		tween.tween_property(self, "scale", Vector2.ONE * buttonHoverSizeModifier, tweenDuration)
		tween.parallel().tween_property($"../Settings", "position", settingsButtonPos + Vector2(0, 15), tweenDuration)
		tween.parallel().tween_property($"../Mr Kinney Jumpscare", "position", jumpscareButtonPos + Vector2(0, 15), tweenDuration)


func _on_mouse_exited() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	if isPlayButtonActive == false:
		tween.tween_property(self, "scale", Vector2.ONE, tweenDuration)
		tween.parallel().tween_property($"../Settings", "position", settingsButtonPos, tweenDuration)
		tween.parallel().tween_property($"../Mr Kinney Jumpscare", "position", jumpscareButtonPos, tweenDuration)


#this should be called after pressing the back button after pressing the play button
#this function restores the original buttons' properties
func RestoreButtons():
	isPlayButtonActive = false
	$"../Settings".disabled = false
	$"../Mr Kinney Jumpscare".disabled = false
	emit_signal("mouse_exited")
