@tool
extends Node

var map: bool = true
const width = 16
const height = 16
var Ncheck = -width
var Echeck = 1
var Scheck = width
var Wcheck = -1
var chnx: int
var chny: int
var visited = []
var tiles = []
var path = []
var neighbors = []
var selected
var state
var stateprev = 0
var id = 0

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
				Maze.set_cell(Vector2i(x, y), 16, Vector2i(0, 0), 0)
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

func tile_state(selected, cx, cy):
	state = tiles[crntpos(cx, cy)]
	if selected == Ncheck:
		state -= 1
	if selected == Echeck:
		state -= 2
	if selected == Scheck:
		state -= 4
	if selected == Wcheck:
		state -= 8
	state += stateprev
	
	Maze.set_cell(Vector2i(cx, cy), (state), Vector2i(0, 0), 0)
	tiles[crntpos(cx, cy)] = (state)
	stateprev = 0
	
	if selected == Ncheck:
		stateprev -= 4
	if selected == Echeck:
		stateprev -= 8
	if selected == Scheck:
		stateprev -= 1
	if selected == Wcheck:
		stateprev -= 2

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
	Maze.set_cell(Vector2i(cx, cy), 0, Vector2i(0, 0), 0)
	
	for i in (width*height)*2:
		state = tiles[crntpos(cx, cy)]
		neighbors.clear()
		visited[crntpos(cx, cy)] = 0
		check_neighbors(crntpos(cx, cy))
		#back track
		if neighbors.is_empty() == true:
			if path.back() == Ncheck:
				chny = +1
			if path.back() == Echeck:
				chnx = -1
			if path.back() == Scheck:
				chny = -1
			if path.back() == Wcheck:
				chnx = +1
			path.pop_back()
		#succesful checks
		if neighbors.is_empty() == false:
			selected = neighbors.pick_random()
			path.push_back(selected)
			if selected == Ncheck:
				chny = -1
			if selected == Echeck:
				chnx = +1
			if selected == Scheck:
				chny = +1
			if selected == Wcheck:
				chnx = -1
			tile_state(selected, cx, cy)
		cx += chnx
		cy += chny
		chnx = 0
		chny = 0
		print(cx,",", cy)
		print(neighbors)
		if cx <= 0 or cx >= width:
			print('X')
		if cy <= 0 or cy >= width:
			print('Y')
	print(path)

func _ready():
	tile_gen(width, height)
	path_gen(1, 1)
