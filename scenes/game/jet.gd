extends RigidBody3D
class_name Jet

@export var raycasts: Array[RayCast3D]
@export var mult := 1.

func _physics_process(_delta: float) -> void:
	var v = Input.get_vector("d", "a", "s", "w")
	var b = self.global_transform.basis
	self.apply_central_force(-b.z * v.y * 50)
	self.apply_torque(b.y * v.x * 10)
	for r in raycasts:
		r.force_raycast_update()
		if not r.is_colliding(): return
		var diff := r.get_collision_point() - r.global_position
		var dist := diff.length()
		self.apply_force(b.y / dist * 30, r.position)
	
