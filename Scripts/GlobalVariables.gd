extends Node

var wordChoice : String
var lives : int
var timeLimit : int

var seenWelcomeScreen : bool = false #so the player doesn't have to see welcome screen 24/7

var mainMenuMusicPlaying : bool = false #helps with determining if things should react to music

var isSceneTransitioning : bool = false #helps scene transition nodes to adjust their state
