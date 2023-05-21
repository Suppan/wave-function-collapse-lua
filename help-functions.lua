wfc = {}

grid = {}
dim = 4
name = 'default'
local tiles = {}

function wfc.setupGrid(ntiles)
  for i = 1, dim*dim do
  	local t = {}
  	for n = 1, ntiles do 
	table.insert(t,n)
	end
  	grid[i] = {}
	grid[i] = {
		collapsed = false,
		options = t,
        	pos = i
		}
  end
end

function table.reduced_rand(arr)
	local t = {}
	local pos = math.random(#arr)
	t[1] = arr[pos]
	return t
end

function wfc.member(arr, x)
    for i = 1,#arr do
        if arr[i] == x then return true end
    end
    return false
end

function wfc.checkValid(arr, valid)
    local t = {}
    for i = 1,#arr do
    	if wfc.member(valid,arr[i]) then table.insert(t,arr[i]) end
    end
    return t
end

function wfc.countCollapsed()
    local counter = 0
    for i = 1, dim*dim do
      if grid[i].collapsed then counter = counter+1 end 
    end
    return counter
end

function wfc.montageDraw(tiles,name)
  --draw with imagemagick temrinal tool: https://imagemagick.org/index.php
  local terminal_str = "montage "	
  for i = 1, dim*dim do
		local cell = grid[i]
		if cell.collapsed then terminal_str = terminal_str .." ".. tiles[cell.options[1]] 
		end
  end
  terminal_str = terminal_str .. string.format(" -tile %dx%d -geometry +0+0 -border 0 %s.png",dim,dim,name)
  os.execute(terminal_str)
end

function wfc.print()
    for j = 0, dim-1 do
    	local t = {}
    	for i = 0, dim-1 do
    		local index = i + j * dim 
    		local cell = grid[index+1]
    		table.insert(t,cell.options[1])
		end
		print(table.concat(t,"\t "))
	end
end

return wfc
