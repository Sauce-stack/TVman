extends SceneTree
## Headless guard: fails the build if an expected input action, physics layer or setting is missing.
## Run: godot --headless --path . --script tools/verify_project_config.gd

## Empty until the input map is written. Every action added to project.godot gets a line here.
const REQUIRED_ACTIONS: PackedStringArray = []

const REQUIRED_LAYERS: PackedStringArray = [
	"world",
	"player_body",
	"enemy_body",
	"player_hitbox",
	"enemy_hitbox",
	"player_hurtbox",
	"enemy_hurtbox",
	"interactable",
	"camera_collision",
]

const GAMEPAD_EXEMPT: PackedStringArray = []

const KEYBOARD_EXEMPT: PackedStringArray = []

## Apple Silicon reads ASTC and nothing else, so a macOS export refuses to build without it.
const REQUIRED_SETTINGS: Dictionary[String, Variant] = {
	"physics/3d/physics_engine": "Jolt Physics",
	"rendering/textures/vram_compression/import_etc2_astc": true,
}


func _init() -> void:
	var failures: PackedStringArray = []

	for action: String in REQUIRED_ACTIONS:
		if not InputMap.has_action(action):
			failures.append("missing action: %s" % action)
			continue
		var has_keyboard := false
		var has_gamepad := false
		for event: InputEvent in InputMap.action_get_events(action):
			if event is InputEventKey or event is InputEventMouseButton:
				has_keyboard = true
			elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
				has_gamepad = true
		if not has_keyboard and not KEYBOARD_EXEMPT.has(action):
			failures.append("no keyboard/mouse binding: %s" % action)
		if not has_gamepad and not GAMEPAD_EXEMPT.has(action):
			failures.append("no gamepad binding: %s" % action)

	for index: int in REQUIRED_LAYERS.size():
		var setting := "layer_names/3d_physics/layer_%d" % (index + 1)
		var actual := str(ProjectSettings.get_setting(setting, ""))
		if actual != REQUIRED_LAYERS[index]:
			failures.append(
				"layer %d is %s, expected %s" % [index + 1, actual, REQUIRED_LAYERS[index]]
			)

	if ProjectSettings.get_setting("application/config/version", "") == "":
		failures.append("application/config/version is not set")

	for setting: String in REQUIRED_SETTINGS:
		var actual: Variant = ProjectSettings.get_setting(setting)
		if actual != REQUIRED_SETTINGS[setting]:
			failures.append("%s is %s, expected %s" % [setting, actual, REQUIRED_SETTINGS[setting]])

	if failures.is_empty():
		print(
			(
				"project config OK — %d actions, %d layers, %d settings"
				% [REQUIRED_ACTIONS.size(), REQUIRED_LAYERS.size(), REQUIRED_SETTINGS.size()]
			)
		)
		quit(0)
		return

	for failure: String in failures:
		printerr(failure)
	quit(1)
