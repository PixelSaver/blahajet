extends RigidBody3D
class_name Jet

@export var rest_length := 0.0
@export var spring_strength := 1.0
@export var spring_damping := 0.2
@export var upright_strength := 10.
@export var upright_damping := 0.2
@export var raycasts: Array[RayCast3D]
@export var mult := 1.

func _physics_process(_delta: float) -> void:
	var v = Input.get_vector("d", "a", "s", "w")
	var b = self.global_transform.basis
	var local_vel = b.inverse() * linear_velocity
	
	var comps = []
	for r in raycasts:
		r.force_raycast_update()
		if not r.is_colliding(): continue
		
		var hit_point := r.get_collision_point()
		var current_length := (hit_point - r.global_position).length()
		var compression := current_length - rest_length 
		comps.append(compression)
		if compression >= 0.0: continue
		
		var point_vel = linear_velocity + angular_velocity.cross(r.position)
		var vel_along_spring := point_vel.dot(b.y)
		
		var spring_force = -compression * spring_strength
		var damping_force = -vel_along_spring * spring_damping
		
		self.apply_force(b.y * (spring_force + damping_force), r.position)
	print("Comps: %s" % str(comps))
	
	# Upright
	var axis = b.y.cross(Vector3.UP)
	var angular_damping := Vector3(angular_velocity.x, 0.0, angular_velocity.z) * \
		-upright_damping
	apply_torque(axis * upright_strength + angular_damping)
	
	self.apply_central_force(-b.z * v.y * 50)
	# Bank
	apply_torque(Vector3.UP * v.x * 10.)
	
