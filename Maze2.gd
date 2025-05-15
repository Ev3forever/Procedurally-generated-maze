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

func check_neighbors(currentx, currenty):
	var Ncheck = -width
	var Echeck = 1
	var Scheck = width
	var Wcheck = -1
	print('neighbors')
	#while map == true:
	for i in 128:
		if currentx == 0:
			currentx = 1
		if currenty == 0:
			currenty = 1
		var offset = currentx + (currenty * width) + 1
		visited[offset] = 0
		Maze.set_cell(Vector2i(currentx, currenty), 15, Vector2i(0, 0), 0)
		
		if visited[offset + Ncheck] > 0:
			neighbors.push_back(Ncheck)
		if visited[offset + Echeck] > 0:
			neighbors.push_back(Echeck)
		if visited[offset + Scheck] > 0:
			neighbors.push_back(Scheck)
		if visited[offset + Wcheck] > 0:
			neighbors.push_back(Wcheck)
		
		if neighbors.is_empty() == false:
			selected = neighbors.pick_random()
			path.push_back(selected)
			if selected == Ncheck:
				currenty -= 1
			if selected == Echeck:
				currentx += 1
			if selected == Scheck:
				currenty += 1
			if selected == Wcheck:
				currentx -= 1
		
		while neighbors.is_empty() == true:
			if path.back() == Ncheck or path.back() == Scheck:
				currenty -= path.back()
				path.pop_back()
			if path.back() == Echeck or path.back() == Wcheck:
				currentx -= path.back()
				path.pop_back()
			
			print(neighbors)
			offset = currentx + (currenty * width) + 1
			
			if visited[offset + Ncheck] > 0:
				neighbors.push_back(Ncheck)
			if visited[offset + Echeck] > 0:
				neighbors.push_back(Echeck)
			if visited[offset + Scheck] > 0:
				neighbors.push_back(Scheck)
			if visited[offset + Wcheck] > 0:
				neighbors.push_back(Wcheck)
			print(neighbors)
		
		#if visited.has(end_checks(0)) == true:
			#map = false
		
		print(neighbors)
		neighbors.clear()
	print(currentx)
	print(currenty)
	print(selected)
	print(path)

func _ready():
	tile_gen(width, height)
	check_neighbors(1, 1)
