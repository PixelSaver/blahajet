extends RigidBody3D
class_name Jet

func _physics_process(_delta: float) -> void:
	var v = Input.get_vector("a", "d", "w", "s")
	var dir = Vector3(v.x, 0, v.y).normalized()
	self.apply_central_force(dir * 1000)
	
