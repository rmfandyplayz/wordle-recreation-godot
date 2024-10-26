extends RichTextLabel

#handles some of the logic for the game title
#it's literally just the pulsing title thing lol

@export var objectToPulse : Control

@export var busName : String = "Music"

#how sensititve to audio this thing will be
@export var pulseSensitivity : float = 0.5

@export var minScale : float = 1
@export var maxScale : float = 1.6

#frequencies to take in and process (in Hz)
@export var minFrequency : float = 50
@export var maxFrequency : float = 1000

var audioSpectrum : AudioEffectSpectrumAnalyzerInstance

func _ready() -> void:
	#grabs that audio effect spectrum analyzer thing from the bus
	audioSpectrum = AudioServer.get_bus_effect_instance(AudioServer.get_bus_index(busName), 0) as AudioEffectSpectrumAnalyzerInstance
	if audioSpectrum == null:
		print("[GameTitle.gd > _ready()] oh noes! audio spectrum can't be found!")

func _process(delta: float) -> void:
	if audioSpectrum:
		var amplitude = audioSpectrum.get_magnitude_for_frequency_range(minFrequency, maxFrequency)
		
		#used for targetScale
		var lerpWeight : Vector2 = clamp(amplitude * pulseSensitivity, Vector2.ZERO, Vector2.ONE)
		
		#scale title based on amplitude and sensitivity
		var targetScale = lerp(minScale, maxScale, lerpWeight.length())
		
		if objectToPulse:
			objectToPulse.scale = Vector2(targetScale, targetScale)
