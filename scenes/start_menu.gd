extends PixelMenu
class_name StartMenu

@export var buttons: Array[Button]
const GAME := preload("res://scenes/game/game.tscn")
var ts : Array[Tweenable]
var t : Tween

func _ready() -> void:
	for but in buttons:
		but.pressed.connect(_on_button_pressed.bind(but.name))

func _on_button_pressed(_name) -> void:
	match _name.to_lower():
		"play":
			Global.menu_manager.transition_to_scene(GAME)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("w"):
		start_anim()

func start_anim():
	ts = get_all_tweenables(self)
	if t != null and t.is_running(): t.kill()
	t = default_tween()
	for _t in ts:
		var f = _t.get_final_offset()
		_t.par.offset_transform_position = f
		t.tween_property(_t.par, "offset_transform_position", Vector2.ZERO, 3.)


func end_anim():
	self.hide()
	queue_free()
