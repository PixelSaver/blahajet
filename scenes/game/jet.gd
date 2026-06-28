extends RigidBody3D
class_name Jet

@export var rest_length := 0.0
@export var spring_strength := 1.0
@export var spring_damping := 0.2
@export var upright_strength := 10.
@export var raycasts: Array[RayCast3D]
@export var mult := 1.

func _physics_process(_delta: float) -> void:
	var v = Input.get_vector("d", "a", "s", "w")
	var b = self.global_transform.basis
	
	# Upright
	var up = b.y
	var axis = up.cross(Vector3.UP)
	apply_torque(axis * upright_strength)
	
	
	self.apply_central_force(-b.z * v.y * 50)
	#self.apply_torque(b.y * v.x * 50)
	
	for r in raycasts:
		r.force_raycast_update()
		
		if not r.is_colliding(): continue
		var hit_point := r.get_collision_point()
		var ray_dir : Vector3 = -b.y
		
		var current_length := (hit_point - r.global_position).length()
		var compression := current_length - rest_length
		if compression >= 0.0: continue
		var offset = r.position
		var vel = linear_velocity + angular_velocity.cross(offset)
		var v_upwards = vel.dot(ray_dir)
		var spring_force = compression * spring_strength
		var damping_force = -v_upwards * spring_damping
		
		var total_force = ray_dir * (spring_force + damping_force)
		self.apply_force(total_force, r.position)
		
	
