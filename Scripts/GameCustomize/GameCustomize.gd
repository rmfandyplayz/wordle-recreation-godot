extends Control

#handles a majority of the logic for this scene

var wordChoice : String = GlobalVariables.wordChoice.to_upper()
var lives : int = GlobalVariables.lives
var timeLimit : int = GlobalVariables.timeLimit

var infiniteLives : bool = false
var infiniteTime : bool = false
var stopTimer : bool = false
var gameOver : bool = false

var lowLives : bool = false
var lowTime : bool = false

@onready var wordLength : int = wordChoice.length()

var currentRow : CenterContainer
var currentRowNumber : int = 0
@onready var rowScene = preload("res://Scenes/NodeCollections/Row.tscn")
@onready var rowParent = $Scrolling/VerticalContainer

@onready var currentText : String = "" #used for comparing the new and previous text (used for some functions inside LetterSquareRow.gd)



func _ready() -> void:
	#initializations
	$WordSubmission.max_length = wordLength
	$WordSubmission.editable = false
	
	#set correct letter SFX pitch
	$"GameSfx/FullyCorrect".pitch_scale = 1.0 - (0.5 / wordLength)
	
	#lives text
	if(lives != 0):
		SetLivesText(lives)
	else:
		$"Topbar/Lives Panel/Text".text = "∞"
		infiniteLives = true
	
	#time text
	if timeLimit == -1:
		$"Topbar/Time Panel/Text".text = "∞"
		infiniteTime = true
	else:
		SetTimeText(timeLimit)
	
	#start the game
	StartGame()


#the logic that's needed to start the game itself
func StartGame():
	#fade out loading screen
	await create_tween().tween_property($"Scene Transition/Background Color", "modulate", Color.TRANSPARENT, 0.5).finished
	$"Scene Transition/Background Color".visible = false
	
	#clone the first row
	await CloneRow()
	
	#do the plants vs zombies ready set plant thing
	get_node("GameSfx/PvzReadySetPlant").play()
	$ReadySetGo.visible = true
	await create_tween().tween_property($ReadySetGo, "scale", Vector2(1.4, 1.4), .65).finished
	$ReadySetGo.scale = Vector2(1.15, 1.15)
	$ReadySetGo.text = "Set..."
	await create_tween().tween_property($ReadySetGo, "scale", Vector2(1.5, 1.5), .65).finished
	$ReadySetGo.text = "GO!!!"
	$ReadySetGo.scale = Vector2(1.75, 1.75)
	await get_tree().create_timer(.85).timeout
	$ReadySetGo.visible = false
	
	$WordSubmission.editable = true
	$WordSubmission.grab_focus()
	
	if(infiniteTime == false):
		StartTimer()
	
	await get_tree().create_timer(RandomNumberGenerator.new().randi_range(3, 6)).timeout
	$GameMusic.play()


	
#clones a row of letter squares and sets them to the appropriate number
func CloneRow() -> void:
	var newRow = rowScene.instantiate()
	newRow.name = "Row%d" % currentRowNumber
	rowParent.add_child(newRow)
	get_node("GameSfx/RobloxTrowel").play()
	await newRow.CloneSquares(wordLength)
	currentRow = newRow
	currentRowNumber += 1


#starts the timer and runs its logic
func StartTimer():
	while stopTimer == false and gameOver == false:
		timeLimit -= 1
		await get_tree().create_timer(1).timeout
		SetTimeText(timeLimit)
		
		#aka only do this gimmick thing if the player chooses a time limit over that
		if timeLimit == 31 and gameOver != true:
			lowTime = true
			
			if lowLives == true:
				$GameSpecialMusic.FadeOutLowHealthMusic(1)
				$"GameSpecialMusic/LowTime/Last30Danger".play()
			else:
				$Vignette.modulate = Color.TRANSPARENT
				$Vignette.visible = true
				create_tween().tween_property($Vignette, "modulate", Color.WHITE, 1)
				
				create_tween().tween_property($GameMusic, "volume_db", -60, 1)
				$"GameSpecialMusic/LowTime/Last30Intense".play()
				
				#does that anime effect
				var speedLines = $"Speed Lines".material
				if(lowLives != true): create_tween().tween_property(speedLines, "shader_parameter/line_density", .4, 1)
		
		#change health text color
		if timeLimit == 30 and gameOver != true:
			$"GameSfx/LowOnTime".play()
			$"Topbar/Time Panel/Text".self_modulate = Color.RED
			$Vignette.modulate = Color.WHITE
		
		if timeLimit == 0:
			stopTimer = true
			GameOverOutOfTime()



#takes away a life and runs other logic tied with it
func TakeDamage():
	lives -= 1
	
	$"GameSfx/HurtBump".play()
	$"GameSfx/HurtCrack".play()
	SetLivesText(lives)
			
	if lives <= 2:
		$"Topbar/Lives Panel/Text".self_modulate = Color.RED
	
	#plays that low health SFX and starts low health music (and other logic)
	if (lives == 2 or lives == 1) and lowLives != true and lowTime != true:
		lowLives = true
		$Vignette.modulate = Color.TRANSPARENT
		$Vignette.visible = true
		create_tween().tween_property($Vignette, "modulate", Color.WHITE, 0.8)
		$"GameSfx/LowLives".play()
		
		#does that anime effect
		var speedLines = $"Speed Lines".material
		if(lowTime != true): create_tween().tween_property(speedLines, "shader_parameter/line_density", .4, 1)
		
		await create_tween().tween_property($GameMusic, "volume_db", -60, 4).finished
		await get_tree().create_timer(RandomNumberGenerator.new().randi_range(1, 3)).timeout
		
		if lowTime != true: get_node("GameSpecialMusic/LowHealth").get_children().pick_random().play()

	#does that vignette thing every single time as long as if health isn't low
	if lowLives != true and lowTime != true:
		$Vignette.modulate = Color(1, 1, 1, 0.4)
		$Vignette.visible = true
		if(lowLives != true and lowTime != true): await create_tween().tween_property($Vignette, "modulate", Color.TRANSPARENT, 1).finished
		$Vignette.visible = false
	
	
	
	if lives == 0:
		GameOverDeath()
	



#runs logic for when player lost due to running out of lives
func GameOverDeath():
	if gameOver == false:
		gameOver = true
		#disable everything that's interactable
		$WordSubmission.editable = false
		$WordSubmission.release_focus()
		$"Topbar/Back Button".disabled = true
		stopTimer = true
		
		#additional initializations
		$"Game Over Death/Background Color/TheWord".text = ("[center]the word was " + "\"%s\"" %wordChoice)
		$"Game Over Death/Background Color/TheWord".self_modulate = Color.TRANSPARENT
		$"Game Over Death/Background Color/Menu Button".modulate = Color.TRANSPARENT
		$"Game Over Death/Background Color/Dead".modulate = Color.TRANSPARENT
		
		#play animation + sounds/music logic
		$"GameSfx/Death".play()
		$"Game Over Death/Background Color".visible = true
		$"Game Over Death/Background Color".self_modulate = Color.WHITE
		$"Game Over Death/Background Color/Dead".modulate = Color.WHITE
		
		var speedLines = $"Speed Lines".material
		create_tween().tween_property(speedLines, "shader_parameter/line_density", 0, 1)
		create_tween().tween_property($Vignette, "modulate", Color.TRANSPARENT, 1)
		
		create_tween().tween_property($GameMusic, "volume_db", -60, .25)
		$GameSpecialMusic.FadeOutAllMusic(1.5)
		await get_tree().create_timer(.5).timeout
		create_tween().tween_property($"Game Over Death/Background Color/TheWord", "self_modulate", Color.WHITE, 0.3)
		create_tween().tween_property($"Game Over Death/Background Color/Menu Button", "modulate", Color.WHITE, 0.3)
	
	
	
#runs logic for when player lost due to running out of time
func GameOverOutOfTime():
	if gameOver == false:
		gameOver = true
		#disable everything that's interactable
		$WordSubmission.editable = false
		$WordSubmission.release_focus()
		$"Topbar/Back Button".disabled = true
		
		#additional initializations
		$"Game Over OutOfTime/Background Color/TheWord".text = ("[center]the word was " + "\"%s\"" %wordChoice)
		$"Game Over OutOfTime/Background Color/TheWord".self_modulate = Color.TRANSPARENT
		$"Game Over OutOfTime/Background Color/Menu Button".modulate = Color.TRANSPARENT
		
		#play animation + sounds/music logic
		create_tween().tween_property($GameMusic, "volume_db", -60, .25)
		$GameSpecialMusic.FadeOutAllMusic(1.5)
		$"GameSfx/TimeUp".play()
		$"Game Over OutOfTime/Background Color".visible = true
		
		var speedLines = $"Speed Lines".material
		create_tween().tween_property(speedLines, "shader_parameter/line_density", 0, 1)
		create_tween().tween_property($Vignette, "modulate", Color.TRANSPARENT, 1)
		
		create_tween().tween_property($"Game Over OutOfTime/Background Color", "self_modulate", Color.WHITE, 0.3)
		await create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).tween_property($"Game Over OutOfTime/Background Color/OutOfTime", "scale", Vector2(1, 1), 0.3).finished
		create_tween().tween_property($"Game Over OutOfTime/Background Color/TheWord", "self_modulate", Color.WHITE, 0.3)
		create_tween().tween_property($"Game Over OutOfTime/Background Color/Menu Button", "modulate", Color.WHITE, 0.3)



#logic for when player wins 
func GameWon():
	if gameOver == false:
		gameOver = true
		#disable everything that's interactable
		$WordSubmission.editable = false
		$WordSubmission.release_focus()
		$"Topbar/Back Button".disabled = true
		
		#additional initializations
		$"Game Won/Background Color/SocialCredit".self_modulate = Color.TRANSPARENT
		$"Game Won/Background Color/Menu Button".modulate = Color.TRANSPARENT
		
		#play animation + sounds/music logic
		create_tween().tween_property($GameMusic, "volume_db", -60, .25)
		$GameSpecialMusic.FadeOutAllMusic(1.5)
		$"GameSfx/GameWon".play()
		$"Game Won/Background Color".visible = true
		
		var speedLines = $"Speed Lines".material
		create_tween().tween_property(speedLines, "shader_parameter/line_density", 0, 1)
		create_tween().tween_property($Vignette, "modulate", Color.TRANSPARENT, 1)
		
		create_tween().tween_property($"Game Won/Background Color", "self_modulate", Color.WHITE, 0.3)
		await create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).tween_property($"Game Won/Background Color/Won", "scale", Vector2(1, 1), 0.3).finished
		create_tween().tween_property($"Game Won/Background Color/SocialCredit", "self_modulate", Color.WHITE, 0.3)
		create_tween().tween_property($"Game Won/Background Color/Menu Button", "modulate", Color.WHITE, 0.3)




func SetTimeText(input : int):
	$"Topbar/Time Panel/Text".text = FormatTime(input)
	
func SetLivesText(input):
	var livesText : RichTextLabel = $"Topbar/Lives Panel/Text"
	livesText.text = str(input)
	livesText.pivot_offset.x = livesText.size.x / 2
	livesText.pivot_offset.y = livesText.size.y / 2
	await create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).tween_property(livesText, "scale", Vector2(1.85, 1.85), .1).finished
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC).tween_property(livesText, "scale", Vector2.ONE, .4)
	

#i asked chatgpt to write this for me lol cuz im lazy
func FormatTime(seconds: int) -> String:
	var hours = int(seconds / 3600)
	var minutes = int((seconds % 3600) / 60)
	var secs = int(seconds % 60)

	if hours > 0:
		return "%2d:%02d:%02d" % [hours, minutes, secs]
	elif minutes > 0:
		return "%2d:%02d" % [minutes, secs]
	else:
		return "%2d" % secs



#refers to WordSubmission's signal
#updates the squares correctly and plays the correct animations
var preventSignal = false
func _on_text_changed(new_text: String) -> void:
	new_text = new_text.to_upper()
	
	if preventSignal == false:
		currentRow.ChangeSquaresText(currentText, new_text)
		currentText = new_text


#refers to WordSubmission's signal
#checks the correctness of the word and does stuff appropriately
var makeInactive = false
func _on_text_submitted(new_text: String) -> void:
	new_text = new_text.to_upper()
	
	#check if they even entered all the words
	if(len($WordSubmission.text) != wordLength and makeInactive == false):
		#plays the effect on the textbox if they didn't enter all the words needed
		makeInactive = true
		$WordSubmission.editable = false
		$WordSubmission.self_modulate = Color("#ff6666")
		
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		var original_position = $WordSubmission.position
		
		#play sound
		$"GameSfx/VineBoom".play()
		
		#shake effect
		for i in range(1, 7):
			tween.tween_property($WordSubmission, "position", original_position + Vector2(48 - 8*i, 0), 0.06)
			tween.tween_property($WordSubmission, "position", original_position - Vector2(48 - 8*i, 0), 0.06)
		
		
		await tween.finished
		makeInactive = false
		$WordSubmission.self_modulate = Color("#ffffff")
		$WordSubmission.editable = true
		return
	
	#otherwise, do the actual checking of word correctedness
	elif(len($WordSubmission.text) == wordLength and makeInactive == false):
		preventSignal = true
		makeInactive = true
		$WordSubmission.editable = false
		var playerWon : bool = await currentRow.CheckSquares(new_text)
		
		if playerWon == true:
			GameWon()
		else:
			if infiniteLives == false:
				TakeDamage()
				await get_tree().create_timer(.5).timeout
			
			#clone another row of squares and restart the timer if appropriate
			if gameOver == false:
				await CloneRow()
				$"GameSfx/FullyCorrect".pitch_scale = 1.0 - (0.5 / wordLength)
				currentText = "" #to prevent THAT bug
				$WordSubmission.clear()
				$WordSubmission.editable = true
				preventSignal = false
				makeInactive = false
				
				

func _on_gameOverTimeOut_menu_button_pressed() -> void:
	$"Game Over OutOfTime/Background Color/Menu Button".disabled = true
	
	await create_tween().tween_property($"Game Over OutOfTime/Background Color", "modulate", Color.TRANSPARENT, 0.3).finished
	$"Topbar/Back Button".BackToMenu()

func _on_gameOverDeath_menu_button_pressed() -> void:
	$"Game Over Death/Background Color/Menu Button".disabled = true
	
	await create_tween().tween_property($"Game Over Death/Background Color", "modulate", Color.TRANSPARENT, 0.3).finished
	$"Topbar/Back Button".BackToMenu()

func _on_gameWon_menu_button_pressed() -> void:
	$"Game Won/Background Color/Menu Button".disabled = true
	
	await create_tween().tween_property($"Game Won/Background Color", "modulate", Color.TRANSPARENT, 0.3).finished
	$"Topbar/Back Button".BackToMenu()
