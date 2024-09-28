extends Button

#this script handles the logic and animations for the play button

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
var mouseHovering : bool = false

#positions for the play options buttons
@onready var defPresetPos = $"Default Preset".position
@onready var customizePos = $Customize.position





func _ready() -> void:
	DisplayServer.window_set_title("made with your mom engine (real) (100% legit) (truth) (not lie)")


func _on_pressed() -> void:
	if isPlayButtonActive == true:
		SwitchBackToPlayButton()
	else:
		SwitchToPlayOptionsMenu()

func _on_mouse_entered() -> void:
	if isPlayButtonActive == false:
		var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
		tween.tween_property(self, "scale", Vector2.ONE * buttonHoverSizeModifier, tweenDuration)
		tween.parallel().tween_property($"../Settings", "position", settingsButtonPos + Vector2(0, 15), tweenDuration)
		tween.parallel().tween_property($"../Mr Kinney Jumpscare", "position", jumpscareButtonPos + Vector2(0, 15), tweenDuration)
		mouseHovering = true
	else:
		mouseHovering = true



func _on_mouse_exited() -> void:
	if isPlayButtonActive == false:
		var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
		tween.tween_property(self, "scale", Vector2.ONE, tweenDuration)
		tween.parallel().tween_property($"../Settings", "position", settingsButtonPos, tweenDuration)
		tween.parallel().tween_property($"../Mr Kinney Jumpscare", "position", jumpscareButtonPos, tweenDuration)
		mouseHovering = false
	else:
		mouseHovering = false
		
		
		
#animates the transition to show the buttons that allow the player 
func SwitchToPlayOptionsMenu() -> void:
	emit_signal("mouse_entered")
	disabled = true
	$"../Settings".disabled = true
	$"../Mr Kinney Jumpscare".disabled = true
	#note: the size for the buttons post-pressing-play should be 156 pixels in height.
	
	#play button transitions
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	isPlayButtonActive = true
	tween.tween_property(self, "scale", Vector2.ONE, pressedTweenDuration)
	tween.tween_property(self, "scale", Vector2.ONE * buttonHoverSizeModifier, tweenDuration)
	await tween.finished
	tween.kill()
	
	#fade out the text and icon
	var tween2 = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween2.tween_property($"Play Text", "self_modulate", Color.TRANSPARENT, 0.4)
	tween2.parallel().tween_property($"Play Button Image", "self_modulate", Color.TRANSPARENT, 0.4)
	tween2.tween_property(self, "size", Vector2(130, originalButtonSize.y), 0.3)
	await tween2.finished
	tween2.kill()
	
	#enable play options menu (default, customize, etc)
	#note: position is + 35
	var tween4 = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	$"Default Preset".position.x -= 35
	$Customize.position.x -= 35
	
	$"Default Preset".visible = true
	$Customize.visible = true
	tween4.tween_property($"Default Preset", "position", defPresetPos, 0.3)
	tween4.parallel().tween_property($Customize, "position", customizePos, 0.3)
	tween4.parallel().tween_property($"Default Preset", "modulate", Color.WHITE, 0.3)
	tween4.parallel().tween_property($Customize, "modulate", Color.WHITE, 0.3)
	$"Default Preset".disabled = false
	$Customize.disabled = false
	
	#enable the back button
	var tween3 = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	$"Back Button Image".visible = true
	tween3.tween_property($"Back Button Image", "scale", Vector2.ONE, 0.2)
	
	disabled = false



#this should be called after pressing the back button after pressing the play button
#this function restores the original buttons' properties
func SwitchBackToPlayButton():
	disabled = true
	
	#disable play options button (default, customize, etc)
	var tween4 = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween4.tween_property($"Default Preset", "position", Vector2(defPresetPos.x - 35, defPresetPos.y), 0.3)
	tween4.parallel().tween_property($Customize, "position", Vector2(customizePos.x - 35, customizePos.y), 0.3)
	tween4.parallel().tween_property($"Default Preset", "modulate", Color.TRANSPARENT, 0.3)
	tween4.parallel().tween_property($Customize, "modulate", Color.TRANSPARENT, 0.3)
	await tween4.finished
	
	$"Default Preset".visible = false
	$"Default Preset".disabled = true
	$Customize.visible = false
	$Customize.disabled = true
	
	isPlayButtonActive = false
	
	#disable back button
	var tween2 = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween2.tween_property($"Back Button Image", "scale", Vector2.ZERO, 0.35)	
	await tween2.finished
	$"Back Button Image".visible = false
	
	#restore the play button
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "size", originalButtonSize, 0.3)
	tween.tween_property($"Play Text", "self_modulate", Color.WHITE, 0.4)
	tween.parallel().tween_property($"Play Button Image", "self_modulate", Color.WHITE, 0.4)
	
	await tween.finished
	
	#restore other buttons
	disabled = false
	$"../Settings".disabled = false
	$"../Mr Kinney Jumpscare".disabled = false
	if mouseHovering == false:
		emit_signal("mouse_exited")
