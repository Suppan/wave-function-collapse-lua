require 'help-functions'

local r = os.time() -- to lock: set here random seed (ut)
print("random seed = " .. r)
math.randomseed(r)

local tiles = {
	"tileSet/blank.png",
	"tileSet/up.png",
	"tileSet/right.png",
	"tileSet/down.png",
	"tileSet/left.png"
	}

local theoptions = {}
for i = 1, #tiles do 
	table.insert(theoptions,i)
end


dim = 10
name = 'demo'

-- clockwise order: up/right7down/left
-- constraints:
local rules = {
			--blank(=1)
		       {{1,2},	    -- possible option for blank when go up
			{1,3},	    -- posscble option for blank when go right 
			{1,4},	    -- possible option for blank when go down 
			{1,5}},	    -- possible option for blank when go left 	
			--up(=2)
		       {{3,5,4},
		 	{5,2,4},
		 	{1,4},
		 	{3,2,4}},
		 	--right(=3)
		       {{3,5,4},
			{5,2,4},
			{3,5,2},
			{1,5}},	
			--down(=4)
	               {{1,2},
			{5,2,4},
			{3,5,2},
			{3,2,4}},	
			--left(=5)
		       {{3,5,4},
			{1,3},
			{3,5,2},
			{2,4,3}}	
}


wfc.setupGrid(#tiles)

local stopcounter = 0
while (wfc.countCollapsed() < dim*dim) and (stopcounter < 100000) do -- (safety limit with stopcounter)

    stopcounter = stopcounter + 1 
    
    local minEntropy = #tiles

    for i = 1, dim*dim do
    		local cell = grid[i]
    		if not cell.collapsed and #cell.options < minEntropy then minEntropy = #cell.options end
    end

    local minEntropyPos = {}

    for i = 1, dim*dim do
    		local cell = grid[i]
    		if not cell.collapsed and #cell.options == minEntropy then table.insert(minEntropyPos,i)  end
    end

    local collapsCand = table.reduced_rand(minEntropyPos)[1]
    grid[collapsCand].collapsed = true
    grid[collapsCand].options = table.reduced_rand(grid[collapsCand].options)

    for j = 0, dim-1 do
    	for i = 0, dim-1 do
    		local index = i + j * dim 
    		local cell = grid[index+1]
            if (#cell.options == 1) then 
                cell.collapsed = true
            end

    	    if not cell.collapsed then
    	    local allOptions = {}
    	    for y = 1, #theoptions do table.insert(allOptions,theoptions[y]) end

    	    -- Look up
            if (j > 0) then
            local up_cell = grid[1 + i + (j - 1) * dim]
            local validOptions = {}
            for _, option in ipairs(up_cell.options) do
                local valid = rules[option][3]; --3 -> down
                for _, optionx in ipairs(valid) do
                    table.insert(validOptions,optionx)
                end
            end
            allOptions = wfc.checkValid(allOptions, validOptions)
            end
    	    -- Look right
            if (i < dim - 1) then
            local right_cell = grid[1+ i + 1 + j * dim]
            local validOptions = {}
            for _, option in ipairs(right_cell.options) do
                local valid = rules[option][4]; --4 -> left
                for _, optionx in ipairs(valid) do
                    table.insert(validOptions,optionx)
                end
            end
            allOptions = wfc.checkValid(allOptions, validOptions)
            end
    	    -- Look down
            if (j < dim - 1) then
            local down_cell = grid[1+ i + (j + 1) * dim]
            local validOptions = {}
            for _, option in ipairs(down_cell.options) do
                local valid = rules[option][1]; --1 -> up
                for _, optionx in ipairs(valid) do
                    table.insert(validOptions,optionx)
                end
            end
            allOptions = wfc.checkValid(allOptions, validOptions)
            end
    	    -- Look left
            if (i > 0) then
            local left_cell = grid[1 + i - 1 + j * dim];
            local validOptions = {}
            for _, option in ipairs(left_cell.options) do
                local valid = rules[option][2]; --2 -> right
                for _, optionx in ipairs(valid) do
                    table.insert(validOptions,optionx)
                end
            end
            allOptions = wfc.checkValid(allOptions, validOptions)
            end
            -- set the remain options
            if (#allOptions > 0) then 
                cell.options = allOptions
            end
    	 end
      end
   end  
end

wfc.montageDraw(tiles,name)
wfc.print()
