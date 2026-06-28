extends RigidBody3D
class_name Jet

@export var raycasts: Array[RayCast3D]
@export var r_front: RayCast3D
@export var r_left: RayCast3D
@export var r_right: RayCast3D
@export var mult := 1.

func _physics_process(_delta: float) -> void:
	var v = Input.get_vector("d", "a", "s", "w")
	var b = self.global_transform.basis
	self.apply_central_force(-b.z * v.y * 50)
	self.apply_torque(b.y * v.x * 10.0)
	self.apply_torque(b.z * v.x * 1.)
	r_front.force_raycast_update()
	for r in raycasts:
		if not r.is_colliding(): return
		var diff := r.get_collision_point() - r.global_position
		var dist := diff.length()
		self.apply_force(Vector3.UP / dist * 100, r.position)
	
