extends Control

## Custom menu class with animation in and animation out
class_name PixelMenu

var is_animating = false


func start_anim():
	push_error("Pixel Menu anim functions unfulfilled")


func end_anim():
	push_error("Pixel Menu anim functions unfulfilled")


func default_tween() -> Tween:
	var t = create_tween().set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	return t

static func get_all_tweenables(root: Node) -> Array[Tweenable]:
	var out: Array[Tweenable] = []
	_dfs_collect(root, out)
	return out


static func _dfs_collect(node: Node, out: Array[Tweenable]) -> void:
	for child in node.get_children():
		if child is Tweenable:
			out.append(child)

		if child.get_child_count() > 0:
			_dfs_collect(child, out)
