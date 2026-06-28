extends PixelMenu
class_name StartMenu

var ts : Array[Tweenable]
var t : Tween

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
	pass
