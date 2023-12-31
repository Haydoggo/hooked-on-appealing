@tool
class_name WorldMap extends TileMap

enum TileProperty {
	NONE = 0,
	GRAPPLE = 1,
	BOOST = 2,
	JUMP = 4,
	DEATH = 8,
	FRAGILE = 16,
}

const TILE_PROPERTIES = {
	Vector3i(0,0,0) : TileProperty.GRAPPLE,
	Vector3i(1,0,0) : TileProperty.GRAPPLE | TileProperty.BOOST,
	Vector3i(2,0,0) : TileProperty.GRAPPLE | TileProperty.JUMP,
	Vector3i(3,0,0) : TileProperty.DEATH,
	
	# Sheet 2
	# Spikes
	Vector3i(9,2,2) : TileProperty.DEATH,
	Vector3i(9,3,2) : TileProperty.DEATH,
}

func _ready() -> void:
	set_process(Engine.is_editor_hint())

func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_T) and Input.is_key_pressed(KEY_ALT):
		var ei = ClassDB.instantiate("EditorScript").get_editor_interface()
		var s = ei.get_selection()
		s.clear()
		s.add_node(self)
		ei.edit_node(self)

func _use_tile_data_runtime_update(layer: int, _coords: Vector2i) -> bool:
	return not Engine.is_editor_hint() and layer > 0

func _tile_data_runtime_update(_layer: int, _coords: Vector2i, tile_data: TileData) -> void:
	tile_data.set_collision_polygons_count(0, 0)

func global_to_atlas_coords(global_p : Vector2) -> Vector2i:
	var coords = local_to_map(to_local(global_p))
	return get_cell_atlas_coords(0, coords)

func get_alt_index(global_p : Vector2) -> int:
	var coords = local_to_map(to_local(global_p))
	return get_cell_alternative_tile(0, coords)

func get_properties(global_p : Vector2) -> int:
	var coords = local_to_map(to_local(global_p))
	var ac = global_to_atlas_coords(global_p)
	var source = get_cell_source_id(0, coords)
	if source == 3:
		return TileProperty.NONE
	return TILE_PROPERTIES.get(Vector3i(ac.x, ac.y, source), TileProperty.GRAPPLE)
