@tool
extends Node

var map: bool = true
const width = 16
const height = 16
var visited = []
var tiles = []
var path = []
var neighbors = []
var selected

@onready var Maze: TileMapLayer = $TileMapLayer/maze_floor

#generate tile array
func tile_gen(wid, hei):
	var id = 0
	for i in (wid*hei):
		tiles.push_back(id)
		id += 1
	print('tile set id')
	print(tiles)
	#generate edges
	var edge = 0
	id = 1
	for i in (wid*hei):
		visited.push_back(id)
		id += 1
	
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
				Maze.set_cell(Vector2i(x, y), 0, Vector2i(0, 0), 0)
			else:
				Maze.set_cell(Vector2i(x,y), 16, Vector2i(0,0), 0)
			x += 1
			id += 1
		y += 1
		x = 0

func end_checks(number):
	return number > 0

func path_gen(crntx, crnty):
	var Ncheck = -width
	var Echeck = 1
	var Scheck = width
	var Wcheck = -1
	visited[crntx + (crnty * width) + 1]
	print('neighbors')
	if crntx <= 0:
		crntx = 1
	if crnty <= 0:
		crnty = 1
	
	for I in 128:
		neighbors.clear()
		var offset = crntx + (crnty * width) + 1
		visited[offset] = 0
		Maze.set_cell(Vector2i(crntx, crnty), 15, Vector2i(0, 0), 0)
		
		if visited[offset + Ncheck] > 0:
			neighbors.push_back(Ncheck)
		if visited[offset + Echeck] > 0:
			neighbors.push_back(Echeck)
		if visited[offset + Scheck] > 0:
			neighbors.push_back(Scheck)
		if visited[offset + Wcheck] > 0:
			neighbors.push_back(Wcheck)
	
		if neighbors.is_empty() == true:
			if path.back() == Ncheck:
				crnty -= 1
			if path.back() == Echeck:
				crntx += 1
			if path.back() == Scheck:
				crnty += 1
			if path.back() == Wcheck:
				crntx -= 1
			path.pop_back()
	
		if neighbors.is_empty() == false:
			path.push_back(neighbors.pick_random())
			if neighbors.pick_random() == Ncheck:
				crnty -= 1
			if neighbors.pick_random() == Echeck:
				crntx += 1
			if neighbors.pick_random() == Scheck:
				crnty += 1
			if neighbors.pick_random() == Wcheck:
				crntx -= 1
		print(neighbors)
	print(crntx, crnty)
	print(path)

func _ready():
	tile_gen(width, height)
	path_gen(1, 1)
