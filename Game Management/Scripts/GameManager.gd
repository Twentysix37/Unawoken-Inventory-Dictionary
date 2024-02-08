extends Node
class_name GameManager

signal HitNewTier(percent : float)

@onready var PlayerRef : Player
@onready var Cam : MC
@onready var Level : LevelController

@onready var Anxiety : float = 0
@onready var FillTween : Tween
@onready var TimeTween : Tween
@export var FillTimeInMinutes : float
@onready var FillTimeInSeconds : float

@onready var SignalTimer : Timer = $"Signal Timer"

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	PlayerRef = $Player
	Cam = $MainCamera
	
	PlayerRef.PlayerDied.connect(PlayerDeath)
	PlayerRef.PlayerHit.connect(HitStop)
	
	if get_child(0) is LevelController:
		Level = get_child(0)
	
	if GameSettings.RespawnPoint != Vector2.ZERO:
		PlayerRef.position = Vector2(GameSettings.RespawnPoint.x, (GameSettings.RespawnPoint.y + 25))
		print("Spawn Position: " + str(PlayerRef.position))
		get_tree().get_first_node_in_group("Cameras").position = PlayerRef.position
		
	for i in Level.Destructables.size():
		Level.Destructables[i].CallScreenShake.connect(Cam.ApplyShake)
		
	StartFill()
	
func _process(delta):
	Anxiety = snapped(Anxiety, 0.01)
	
	if SignalTimer != null && SignalTimer.is_stopped():
		if Anxiety == 0.25:
			print("Launching signal for 25%\n")
			HitNewTier.emit(Anxiety)
			SignalTimer.start()
		elif Anxiety == 0.5:
			print("Launching signal for 50%\n")
			HitNewTier.emit(Anxiety)
			SignalTimer.start()
		elif Anxiety == 0.75:
			print("Launching signal for 75%\n")
			HitNewTier.emit(Anxiety)
			SignalTimer.start()
		elif Anxiety == 1.00:
			print("Launching signal for 100%\n")
			HitNewTier.emit(Anxiety)
			SignalTimer.queue_free()

func HitStop(EffectTime : float):
	get_tree().paused = true
	Cam.ApplyShake(1, EffectTime)
	await get_tree().create_timer(EffectTime).timeout
	get_tree().paused = false
	
func CamShake(intensity : float, duration : float):
	Cam.ApplyShake(intensity, duration)

func PlayerDeath(location : Vector2):
	Cam.Spotlight(location)
	await get_tree().create_timer(5).timeout
	get_tree().reload_current_scene()

func StartFill():
	TimeTween = get_tree().create_tween()
	FillTimeInSeconds = snapped((FillTimeInMinutes * 60), 0.01)
	FillTween = get_tree().create_tween()
	print("\nStarting Anxiety fill: " + str(Anxiety) + " will be 100% in: " + str(FillTimeInSeconds) + " seconds / " + str(FillTimeInMinutes) + " minutes")
	FillTween.tween_property(self, "Anxiety", 1, FillTimeInSeconds)
	TimeTween.tween_property(self, "FillTimeInMinutes", 0, FillTimeInSeconds)

func RestartAnxietyFill(time : float, amount : float):
	FillTween.stop()
	TimeTween.stop()
	FillTween = null
	TimeTween = null
	#print("Current Seconds: " + str(FillTimeInMinutes * 60) + " + New Seconds: " + str(time * 60) + " = " + str(snapped((FillTimeInMinutes * 60) + (time * 60), 0.01)))
	FillTimeInMinutes += time
	#print("New Time in seconds: " + str(FillTimeInMinutes * 60) + " // Minutes: " + str(FillTimeInMinutes))
	
	var newFloat : float = amount * 0.01
	var newValue
	
	if Anxiety - newFloat <= 0.00:
		newValue = 0
	else:
		newValue = Anxiety - newFloat
		
	var newValueTween = get_tree().create_tween()
	newValueTween.tween_property(self, "Anxiety", newValue, 0.5)
	await newValueTween.finished
	StartFill()
	
