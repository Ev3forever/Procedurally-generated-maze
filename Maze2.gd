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

@export var tile_state : Dictionary[int, bool]
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

func path_gen(crntx, crnty):
	var Ncheck = -width
	var Echeck = 1
	var Scheck = width
	var Wcheck = -1
	var selected
	visited[crntx + (crnty * width)] = 0
	print('neighbors')
	if crntx <= 0:
		crntx = 1
	if crnty <= 0:
		crnty = 1
	
	for I in 128:
		neighbors.clear()
		var offset = crntx + (crnty * width)
		visited[offset] = 0
		Maze.set_cell(Vector2i(crntx, crnty), 15, Vector2i(0, 0), 0)
		#neighbor checking
		if visited[offset + Ncheck] > 0:
				neighbors.push_back(Ncheck)
				print('Ncheck')
		if visited[offset + Echeck] > 0:
				neighbors.push_back(Echeck)
				print('Echeck')
		if visited[offset + Scheck] > 0:
				neighbors.push_back(Scheck)
				print('Scheck')
		if visited[offset + Wcheck] > 0:
				neighbors.push_back(Wcheck)
				print('Wcheck')
				
		#back track
		if neighbors.is_empty() == true:
			if path.back() == Ncheck:
				crnty += 1
			if path.back() == Echeck:
				crntx -= 1
			if path.back() == Scheck:
				crnty -= 1
			if path.back() == Wcheck:
				crntx += 1
			path.pop_back()
		#succesful checks
		if neighbors.is_empty() == false:
			selected = neighbors.pick_random()
			path.push_back(selected)
			if selected == Ncheck:
				crnty -= 1
			if selected == Echeck:
				crntx += 1
			if selected == Scheck:
				crnty += 1
			if selected == Wcheck:
				crntx -= 1
		
		print(crntx,",", crnty)
		print(neighbors)
		
		if crntx <= 0 or crntx >= width:
			print('X fucked')
		if crnty <= 0 or crnty >= width:
			print('Y fucked')
		
	print(path)

func _ready():
	tile_gen(width, height)
	path_gen(1, 1)
