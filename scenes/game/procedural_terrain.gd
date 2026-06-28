@tool
extends StaticBody3D
class_name ProceduralTerrain
@export var height_scale := 3. :
	set(val):
		height_scale = val
@export var noise : FastNoiseLite :
	set(val):
		noise = val
@export var map_size := Vector2i(256, 256) :
	set(val):
		map_size = val
@export_tool_button("Reload noise") var reload_noise_action = load_noise
@onready var col: CollisionShape3D = $CollisionShape3D
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
func _ready() -> void:
	if Engine.is_editor_hint():
		load_noise()

func load_noise() -> void:
	var shape = HeightMapShape3D.new()
	var heights = PackedFloat32Array()
	heights.resize(map_size.x * map_size.y)
	
	for z in range(map_size.y):
		for x in range(map_size.x):
			heights[z * map_size.x + x] = noise.get_noise_2d(x, z) * height_scale
			
	shape.map_width = map_size.x
	shape.map_depth = map_size.y
	shape.map_data = heights
	col.shape = shape
	
	build_mesh(heights)

func build_mesh(heights: PackedFloat32Array) -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var half := Vector2(map_size) * 0.5
	for z in range(map_size.y - 1):
		for x in range(map_size.x - 1):
			var i00 = z * map_size.x + x
			var i10 = z * map_size.x + (x + 1)
			var i01 = (z + 1) * map_size.x + x
			var i11 = (z + 1) * map_size.x + (x + 1)
			var p00 = Vector3(x - half.x, heights[i00], z - half.y)
			var p10 = Vector3(x + 1 - half.x, heights[i10], z - half.y)
			var p01 = Vector3(x - half.x, heights[i01], z + 1 - half.y)
			var p11 = Vector3(x + 1 - half.x, heights[i11], z + 1 - half.y)
			# triangle 1
			st.set_uv(Vector2(x, z))
			st.add_vertex(p00)
			st.set_uv(Vector2(x, z + 1))
			st.add_vertex(p10)
			st.set_uv(Vector2(x + 1, z))
			st.add_vertex(p01)
			# triangle 2
			st.set_uv(Vector2(x + 1, z))
			st.add_vertex(p10)
			st.set_uv(Vector2(x, z + 1))
			st.add_vertex(p11)
			st.set_uv(Vector2(x + 1, z + 1))
			st.add_vertex(p01)
	st.generate_normals()
	var mesh := st.commit()
	mesh_instance.mesh = mesh
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.3, 0.8, 0.3)
	mesh_instance.material_override = mat
