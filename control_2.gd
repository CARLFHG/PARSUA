extends Control

@onready var button: Button = $Button
@onready var video: VideoStreamPlayer = $VideoStreamPlayer
@onready var hitbox: Area2D = $VideoStreamPlayer/Area2D

# 🔥 DAMAGE SETTINGS
var damage := 10
var damage_cooldown := 0.5 # seconds between hits per enemy

# 🎞️ ANIMATION SPEED (SLOW THIS DOWN)
var slide_time := 0.3 # ← INCREASE THIS to make it slower

var start_pos: Vector2
var center_pos: Vector2
var hit_timers := {}

func _ready():
	var screen_size = get_viewport_rect().size

	start_pos = Vector2(-video.size.x, (screen_size.y - video.size.y) / 2)
	center_pos = Vector2(
		(screen_size.x - video.size.x) / 2,
		(screen_size.y - video.size.y) / 2
	)

	video.position = start_pos
	video.visible = false

	button.pressed.connect(_on_button_pressed)
	hitbox.body_entered.connect(_on_body_entered)

func _on_button_pressed():
	video.visible = true
	video.play()

	var tween = create_tween()
	tween.tween_property(
		video,
		"position",
		center_pos,
		slide_time  # 👈 SLOW HERE
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

# 💥 DAMAGE LOGIC
func _on_body_entered(body):
	if not body.is_in_group("enemies"):
		return

	if hit_timers.has(body):
		return

	if body.has_method("take_damage"):
		body.take_damage(damage)

	hit_timers[body] = true

	await get_tree().create_timer(damage_cooldown).timeout
	hit_timers.erase(body)
