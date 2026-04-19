extends GdUnitTestSuite


func test_vector2() -> void:
	# A Vector2 is just two numbers.
	# The meaning depends on how we use it:
	# - position: a place in space
	# - direction: an arrow
	# - velocity: movement rate
	# - offset: a relative shift
	
	var pos := Vector2(100, 50)
	print("position: ", pos)
	# Meaning: x=100, y=50
	# In 2D screen/game coordinates, that usually means:
	# - 100 pixels to the right
	# - 50 pixels downward from origin

	var dir := Vector2.RIGHT
	print("direction RIGHT: ", dir)
	# Vector2.RIGHT is (1, 0)
	# This is NOT "1 per frame" or "1 per second".
	# It is just a unit vector pointing right.
	# Think: "an arrow pointing right with length 1"

	var velocity := Vector2(200, -50)
	print("velocity: ", velocity)
	# This only becomes "per second" if YOUR code treats it as such.
	# In Godot movement code, velocity usually means:
	# - move right 200 units per second
	# - move up 50 units per second (negative y is up)

	var enemy_pos := Vector2(1, 1)
	var player_pos := Vector2(100, 20)

	# Subtraction gives the arrow from player to enemy
	var to_enemy := enemy_pos - player_pos
	print("to_enemy: ", to_enemy)
	# Result: (-99, -19)
	# Correct reading:
	# "From the player, the enemy is 99 units left and 19 units up"
	# Not "down 19"
	# In Godot, negative y means up

	print("distance to enemy: ", to_enemy.length())
	# length() is the size of that arrow
	# Equivalent to the hypotenuse of a right triangle
	# sqrt(99^2 + 19^2)

	var dir_to_enemy := to_enemy.normalized()
	print("dir_to_enemy normalized: ", dir_to_enemy)
	print("normalized length: ", dir_to_enemy.length())
	# normalized() keeps direction but changes length to 1
	# This is useful when you want direction only, not distance

	var speed := 100.0
	# Usually interpreted as 100 units per second

	var bad_velocity := to_enemy * speed
	print("bad velocity (usually wrong for movement): ", bad_velocity)
	# This is usually NOT what you want.
	# Why?
	# Because to_enemy contains distance already.
	# So the farther the target, the faster the object moves.

	var good_velocity := dir_to_enemy * speed
	print("good velocity: ", good_velocity)
	# This is the usual movement pattern:
	# - get direction to target
	# - multiply by fixed speed
	# Result: move toward target at constant speed

	var delta := 1.0 / 60.0
	var next_pos := player_pos + good_velocity * delta
	print("next_pos after one frame at 60fps: ", next_pos)
	# velocity is usually units per second
	# delta converts that into "how much movement this frame"

	var spawn_pos := player_pos + Vector2(20, 0)
	print("spawn_pos: ", spawn_pos)
	# Yes, this means:
	# spawn 20 units to the right of the player
