class_name InputBuffer
extends RefCounted
## Keeps recent directions in numpad notation relative to facing
## (6 = toward the opponent, 4 = away, 2 = down, 8 = up) for motion inputs.

const SIZE := 40

var dirs: Array[int] = []


func push(inp: Dictionary, facing: int) -> void:
	var xr: int = int(inp.x) * facing
	dirs.append(5 + xr + 3 * int(inp.y))
	if dirs.size() > SIZE:
		dirs.pop_front()


func clear() -> void:
	dirs.clear()


## True if seq (e.g. [2, 3, 6]) was entered, in order, within the last window frames.
func motion(seq: Array, window := 15) -> bool:
	var idx := seq.size() - 1
	var n := dirs.size()
	var stop := maxi(-1, n - 1 - window)
	for i in range(n - 1, stop, -1):
		if dirs[i] == seq[idx]:
			idx -= 1
			if idx < 0:
				return true
	return false


## Double tap toward (dirn = 1) or away (dirn = -1).
func dash(dirn: int) -> bool:
	var want := 6 if dirn > 0 else 4
	var n := dirs.size()
	if n < 3 or dirs[n - 1] != want or dirs[n - 2] == want:
		return false
	var seen_neutral := false
	for i in range(n - 2, maxi(-1, n - 14), -1):
		if dirs[i] == 5:
			seen_neutral = true
		elif dirs[i] == want and seen_neutral:
			return true
		else:
			return false
	return false
