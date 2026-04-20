class_name ArrayUtils

static func in_array_is_same(arr: Array, target: Variant) -> bool:
	for item:Variant in arr:
		if is_same(item, target):
			return true
	return false
