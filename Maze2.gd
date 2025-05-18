@tool
extends Node

var map: bool = true
const width = 16
const height = 16
var Ncheck = -width
var Echeck = 1
var Scheck = width
var Wcheck = -1
var N = 1
var E = 2
var S = 4
var W = 8
var visited = []
var tiles = []
var path = []
var neighbors = []
var selected
var state = 15
var id = 0

@export var tile_state : Dictionary[int, bool]
@onready var Maze: TileMapLayer = $TileMapLayer/maze_floor

#generate tile array
func tile_gen(wid, hei):
	var id = 0
	for i in (wid*hei):
		tiles.push_back(15)
		id += 1
	print('tile set id')
	print(tiles)
	#generate edges
	var edge = 0
	id = 1
	for i in (wid*hei):
		visited.push_back(1)
	
	for i in wid:
		visited[edge] = 0
		edge += 1
	
	for i in wid - 2:
		visited[edge] = 0
		edge += wid-1
		visited[edge] = 0
		edge += 1
	
	for i in wid:
		visited[edge] = 0
		edge += 1
	print('visited locations')
	print(visited)
	#generate visuals
	id = 0
	var x = 0
	var y = 0
	for p in hei:
		for o in wid:
			var check = visited[id]
			if check > 0:
				Maze.set_cell(Vector2i(x, y), 15, Vector2i(0, 0), 0)
			else:
				Maze.set_cell(Vector2i(x,y), 16, Vector2i(0,0), 0)
			x += 1
			id += 1
		y += 1
		x = 0

func crntpos(x, y):
	return x + (y * width)

func check_neighbors(crntpos):
	if visited[crntpos + Ncheck] > 0:
		neighbors.push_back(Ncheck)
	if visited[crntpos + Echeck] > 0:
		neighbors.push_back(Echeck)
	if visited[crntpos + Scheck] > 0:
		neighbors.push_back(Scheck)
	if visited[crntpos + Wcheck] > 0:
		neighbors.push_back(Wcheck)

func end_loop(number):
	return number > 0

func path_gen(cx, cy):
	var selected
	if cx <= 0:
		cx = 1
	if cx >= width - 1:
		cx = width - 2
	if cy <= 0:
		cy = 1
	if cy >= height - 1:
		cy = height - 2
	
	for i in 256:
		state = tiles[crntpos(cx, cy)]
		neighbors.clear()
		visited[crntpos(cx, cy)] = 0
		check_neighbors(crntpos(cx, cy))
		#back track
		if neighbors.is_empty() == true:
			if path.back() == Ncheck:
				cy += 1
			if path.back() == Echeck:
				cx -= 1
			if path.back() == Scheck:
				cy -= 1
			if path.back() == Wcheck:
				cx += 1
			path.pop_back()
		#succesful checks
		if neighbors.is_empty() == false:
			selected = neighbors.pick_random()
			path.push_back(selected)
			if selected == Ncheck:
				cy -= 1
				state -= N
			if selected == Echeck:
				cx += 1
				state -= E
			if selected == Scheck:
				cy += 1
				state -= S
			if selected == Wcheck:
				cx -= 1
				state -= W
		Maze.set_cell(Vector2i(cx, cy), state, Vector2i(0, 0), 0)
		print(cx,",", cy)
		print(neighbors)
		if cx <= 0 or cx >= width:
			print('X fucked')
		if cy <= 0 or cy >= width:
			print('Y fucked')
	print(path)

func _ready():
	tile_gen(width, height)
	path_gen(1, 1)
