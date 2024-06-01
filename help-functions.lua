
function member(arr, x)
    for i = 1,#arr do
        if arr[i] == x then return true end
    end
    return false
end

function rm_dups(arr)
    local hash = {}
    local t = {}
    for i = 1, #arr do
    	local v = arr[i]
        if (not hash[v]) then
        t[#t+1] = v
        hash[v] = true
        end
    end
    return t
end

function round(val)
	local x1 = math.floor(val)
	local x2 = math.ceil(val)
	local res = x1
	if(val - x1 > x2 - val) then res = x2 end
	return res
end

wfc = {}

function wfc.neighbors(num,dimx,dimy)
    local oldx = ((num-1) % dimx) + 1
    local oldy = math.ceil(num / dimx)
    local coll = {}
    --up
    if (oldy > 1) then table.insert(coll,(num - dimx))
    else table.insert(coll,0)
    end
    --right
    if (oldx < dimx) then table.insert(coll,(num + 1))
    else table.insert(coll,0)
    end
    --down
    if (oldy < dimy) then table.insert(coll,(num + dimx))
    else table.insert(coll,0)
    end
    --left
    if (oldx > 1) then table.insert(coll,(num - 1))
    else table.insert(coll,0)
    end
    return coll
end

function wfc.neighbors2(num,dimx,dimy)
    local oldx = ((num-1) % dimx) + 1
    local oldy = math.ceil(num / dimx)
    local coll = {}
    --up
    if (oldy > 1) then table.insert(coll,(num - dimx))
    else table.insert(coll,0)
    end
    --right
    if (oldx < dimx) then table.insert(coll,(num + 1))
    else table.insert(coll,0)
    end
    --down
    if (oldy < dimy) then table.insert(coll,(num + dimx))
    else table.insert(coll,0)
    end
    --left
    if (oldx > 1) then table.insert(coll,(num - 1))
    else table.insert(coll,0)
    end
     --left-up
    if (oldx > 1) and (oldy > 1) then table.insert(coll,(num - 1 - dimx))
    else table.insert(coll,0)
    end   
    --right-up
    if (oldx < dimx) and (oldy > 1) then table.insert(coll,(num + 1 - dimx))
    else table.insert(coll,0)
    end 
    --down-right
    if (oldy < dimy) and (oldx < dimx) then table.insert(coll,(num + 1 + dimx))
    else table.insert(coll,0)
    end
     --down-left
    if (oldy < dimy) and (oldx > 1) then table.insert(coll,(num - 1 + dimx))
    else table.insert(coll,0)
    end         
    return coll
end

function table.collapse(arr)
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

function wfc.countCollapsed(grid,dimx,dimy)
    local counter = 0
    for i = 1, dimx*dimy do
        if grid[i].collapsed then counter = counter+1 end
    end
    return counter
end

function wfc.setupGrid(grid,dimx,dimy,ntiles)
    for i = 1, dimx*dimy do
        local t = {}
        for n = 1, ntiles do
        table.insert(t,n)
        end
    grid[i] = {}
    grid[i] = {
    collapsed = false,
    options = t,
    pos = i}
    end
end


function wfc.show5(arr,ps2pdf_path)
    local dimy = #arr
    local dimx = #arr[1]
    local open_pdf = true
    local xyfact = 20
    local rand = 50
    local pagex = round(dimx * xyfact) + (2 * rand)
    local pagey = round(dimy * xyfact) + (2 * rand)
    local res_path = "wcf5.eps"
    local pdf_path = "wcf5.pdf"
    local file = io.open(res_path, "w")

    file:write("%!PS-Adobe-2.0 EPSF-2.0\n")
    file:write("%%DocumentFonts: Monaco\n")
    file:write("%%BoundingBox: 0 0 " .. pagex .." ".. pagey.."\n")
    file:write("%%EndComments")

    file:write(string.format("\n/unitsquare4 {newpath 0 -%d moveto %d 0 rlineto 0 -%d rlineto -%d 0 rlineto closepath fill } def",
    round(xyfact / 3),round(xyfact / 2),round(xyfact / 3),round(xyfact / 2)))

    file:write(string.format("\n/unitsquare3 {newpath %d -%d moveto %d 0 rlineto 0 -%d rlineto -%d 0 rlineto closepath fill } def",
    round(xyfact / 3),round(xyfact / 2),round(xyfact / 3),round(xyfact / 2),round(xyfact / 3)))

    file:write(string.format("\n/unitsquare1 {newpath %d -%d moveto %d 0 rlineto 0 %d rlineto -%d 0 rlineto closepath fill } def",
    round(xyfact / 3),round(xyfact / 2),round(xyfact / 3),round(xyfact / 2),round(xyfact / 3)))

    file:write(string.format("\n/unitsquare2 {newpath %d -%d moveto %d 0 rlineto 0 -%d rlineto -%d 0 rlineto closepath fill } def",
    round(xyfact / 2),round(xyfact / 3),round(xyfact / 2),round(xyfact / 3),round(xyfact / 2)))

    file:write("\n1 setlinewidth")
    file:write("\n0.8 0.8 0.0 setrgbcolor")

    for j = 1,dimy do
        for i = 1,dimx do
            local valx = arr[j][i]
            local x = round((i-1) * xyfact) + rand
            local y = pagey - round((j-1) * xyfact) - rand
            if (valx == 2) then
                file:write(string.format("\ngsave  %d %d translate 0 unitsquare1 grestore", x , y))
                file:write(string.format("\ngsave  %d %d translate 0 unitsquare2 grestore", x , y))
                file:write(string.format("\ngsave  %d %d translate 0 unitsquare4 grestore", x , y))
            elseif (valx == 3) then
                file:write(string.format("\ngsave  %d %d translate 0 unitsquare1 grestore", x , y))
                file:write(string.format("\ngsave  %d %d translate 0 unitsquare2 grestore", x , y))
                file:write(string.format("\ngsave  %d %d translate 0 unitsquare3 grestore", x , y))
            elseif (valx== 4) then
                file:write(string.format("\ngsave  %d %d translate 0 unitsquare3 grestore", x , y))
                file:write(string.format("\ngsave  %d %d translate 0 unitsquare4 grestore", x , y))
                file:write(string.format("\ngsave  %d %d translate 0 unitsquare2 grestore", x , y))
            elseif (valx == 5) then
                file:write(string.format("\ngsave  %d %d translate 0 unitsquare4 grestore", x , y))
                file:write(string.format("\ngsave  %d %d translate 0 unitsquare3 grestore", x , y))
                file:write(string.format("\ngsave  %d %d translate 0 unitsquare1 grestore", x , y))
            end
        end
    end
    file:write("\nstroke")
    file:write("\n0.8 0.8 0.8 setrgbcolor")
    --senkrechte linien
    local x0 = rand
    for j=1, dimx + 1 do
        file:write("\nnewpath")
        file:write(string.format("\n%d %d moveto",x0, rand))
        file:write(string.format("\n0 %d rlineto", round(dimy * xyfact)))
        file:write("\nstroke\n")
        x0 = x0 + xyfact
    end
    --waggerechte linien
    for j=1, dimy + 1 do
        local y0 = ((j - 1) * xyfact) + rand
        file:write("\nnewpath")
        file:write(string.format("\n%d %d moveto",rand,y0))
        file:write(string.format("\n%d 0 rlineto", round(dimx * xyfact)))
        file:write("\nstroke\n")
    end
    file:write("\nshowpage\n")
    file:close()
    if open_pdf then os.execute(ps2pdf_path .." -dEPSCrop -dPDFSETTINGS=/prepress -sOutputFile=" ..pdf_path.." "..res_path.. ";open " ..pdf_path) end
end



function wfc.print(arr)
    for j = 1, #arr do
		print(table.concat(arr[j],"\t "))
	end
end


function wfc.rand5(dimx,dimy,info)
    name = 'default'
    local ntiles = 5
    local grid = {}
    local theoptions = {}

    for i = 1, ntiles do
    table.insert(theoptions,i)
    end
    wfc.setupGrid(grid,dimx,dimy,ntiles)

    wfc.rules5 = {
        -- blank.png (=1)
        {{1, 2},            --options for neigbour up
         {1, 3},            --options for neigbour right
         {1, 4},            --options for neigbour down
         {1, 5}},           --options for neigbour left
        -- up.png (=2)
        {{3, 4, 5},      --options for neigbour up
         {2, 4, 5},      --options for neigbour right
         {1, 4},            --options for neigbour down
         {2, 3, 4}},     --options for neigbour left
        -- right.png (=3)
        {{3, 4, 5},      --options for neigbour up
         {2, 4, 5},      --options for neigbour right
         {2, 3, 5},      --options for neigbour down
         {1, 5}},           --options for neigbour left
        -- down.png (=4)
        {{1, 2},            --options for neigbour up
         {2, 4, 5},      --options for neigbour right
         {2, 3, 5},      --options for neigbour down
         {2, 3, 4}},     --options for neigbour left
        -- left.png (=5)
        {{3, 4, 5},      --options for neigbour up
         {1, 3},            --options for neigbour right
         {2, 3, 5},      --options for neigbour down
         {2, 3, 4}},     --options for neigbour left
    }

    function wfc.error5(grid)
        local nerrors = 0
        local coll_err_array = {}
        for j = 0, dimy-1 do
            for i = 0, dimx-1 do
                local index = i + j * dimx
                local cell0 = grid[index+1]
                local neigbors = wfc.neighbors(index+1,dimx,dimy)
                local errorx = 0
                if (neigbors[1] > 0) then
                    local cell1 = grid[neigbors[1]]
                    local options0 =  wfc.rules5[cell0.options[1]][1] --1 -> up
                    local options1 =  wfc.rules5[cell1.options[1]][3] --3 -> down
                    if not member(options0,cell1.options[1]) then errorx = errorx + 1 end
                    if not member(options1,cell0.options[1]) then errorx = errorx + 1 end
                end
                if (neigbors[2] > 0) then
                    local cell1 = grid[neigbors[2]]
                    local options0 =  wfc.rules5[cell0.options[1]][2] --2 -> right
                    local options1 =  wfc.rules5[cell1.options[1]][4] --4 -> left
                    if not member(options0,cell1.options[1]) then errorx = errorx + 1 end
                    if not member(options1,cell0.options[1]) then errorx = errorx + 1 end
                end
                if (neigbors[3] > 0) then
                    local cell1 = grid[neigbors[3]]
                    local options0 =  wfc.rules5[cell0.options[1]][3] --3 -> down
                    local options1 =  wfc.rules5[cell1.options[1]][1] --1 -> up
                    if not member(options0,cell1.options[1]) then errorx = errorx + 1 end
                    if not member(options1,cell0.options[1]) then errorx = errorx + 1 end
                end
                if (neigbors[4] > 0) then
                    local cell1 = grid[neigbors[4]]
                    local options0 =  wfc.rules5[cell0.options[1]][4] --4 -> left
                    local options1 =  wfc.rules5[cell1.options[1]][2] --2 -> right
                    if not member(options0,cell1.options[1]) then errorx = errorx + 1 end
                    if not member(options1,cell0.options[1]) then errorx = errorx + 1 end
                end
                if (errorx > 0) and (not member(coll_err_array,neigbors[1])) 
                    and (not member(coll_err_array,neigbors[2]))
                    and (not member(coll_err_array,neigbors[3]))
                    and (not member(coll_err_array,neigbors[4]))
                    then
                    nerrors = nerrors + 1
                    table.insert(coll_err_array,index+1)
                end
            end
        end
        print(nerrors.." errors!")
    end

    local tempCells = {}
    local stopcounter = 0

    while (wfc.countCollapsed(grid,dimx,dimy) < dimx*dimy) and (stopcounter < 100000) do -- 10000 times max (safty)
        stopcounter = stopcounter + 1
        tempCells = rm_dups(tempCells)
        local collapsCand = 1

        if (#tempCells == 0) then
            collapsCand = math.random(dimx*dimy)    --dimx*dimy
            grid[collapsCand].collapsed = true
            grid[collapsCand].options = table.collapse(grid[collapsCand].options)
        else
        local minEntropy = ntiles
        for i = 1, #tempCells do
            local CellPos = tempCells[i]
            local cell = grid[CellPos]
            local lenx = #cell.options
            if not cell.collapsed and lenx < minEntropy then minEntropy = lenx end
        end

        local minEntropyPos = {}
        for i = 1, #tempCells do
            local CellPos = tempCells[i]
                local cell = grid[CellPos]
               if not cell.collapsed and #cell.options == minEntropy then table.insert(minEntropyPos,CellPos)  end
        end
        -- all in tempCells are collapsed...
        if(#minEntropyPos == 0) then
            minEntropy = ntiles
            for i = 1, dimx*dimy do
                local cell = grid[i]
                if not cell.collapsed and #cell.options < minEntropy then minEntropy = #cell.options end
            end
            minEntropyPos = {}
            for i = 1, dimx*dimy do
                local cell = grid[i]
                if not cell.collapsed and #cell.options == minEntropy then table.insert(minEntropyPos,i)  end
            end
        end
        collapsCand = table.collapse(minEntropyPos)[1]
        grid[collapsCand].collapsed = true
        grid[collapsCand].options = table.collapse(grid[collapsCand].options)
        end

        local newNeigbors = wfc.neighbors2(collapsCand,dimx,dimy)
        tempCells = {}
        --[[
        for z = 4, 8 do
		  if (newNeigbors[z] > 0) then 
			table.insert(tempCells,newNeigbors[z])
		  end
	    end--]]
	    
        for z = 1, 4 do
        local newNeighborCellPos = newNeigbors[z]

        if (newNeighborCellPos > 0) then
            table.insert(tempCells,newNeighborCellPos)
            local n = newNeighborCellPos
            local cell = grid[n]
            local newNeigborsUp = wfc.neighbors(n,dimx,dimy)
            local allOptions = {}
            for y = 1, #theoptions do table.insert(allOptions,theoptions[y]) end
                --up
                if (newNeigborsUp[1] > 0) then
                    local nn = newNeigborsUp[1]
                    table.insert(tempCells,nn)
                    local up_cell = grid[nn]
                    local validOptions = {}
                    for i = 1, #up_cell.options do
                        local option = up_cell.options[i]
                        local valid =  wfc.rules5[option][3]; --3 -> down
                        for _, optionx in ipairs(valid) do
                            table.insert(validOptions,optionx)
                        end
                    end
                    allOptions = wfc.checkValid(allOptions, validOptions)
                end
                --rigth
                if (newNeigborsUp[2] > 0) then
                    local nn = newNeigborsUp[2]
                    table.insert(tempCells,nn)
                    local right_cell = grid[nn]
                    local validOptions = {}
                    for i = 1, #right_cell.options do
                        local option = right_cell.options[i]
                        local valid =  wfc.rules5[option][4]; --4 -> left
                        for _, optionx in ipairs(valid) do
                            table.insert(validOptions,optionx)
                        end
                    end
                    allOptions = wfc.checkValid(allOptions, validOptions)
                 end
                --down
                if (newNeigborsUp[3] > 0) then
                    local nn = newNeigborsUp[3]
                    table.insert(tempCells,nn)
                    local down_cell = grid[nn]
                    local validOptions = {}
                    for i = 1, #down_cell.options do
                        local option = down_cell.options[i]
                        local valid =  wfc.rules5[option][1]; --1 -> up
                        for _, optionx in ipairs(valid) do
                            table.insert(validOptions,optionx)
                        end
                    end
                    allOptions = wfc.checkValid(allOptions, validOptions)
                 end
                --left
                if (newNeigborsUp[4] > 0) then
                    local nn = newNeigborsUp[4]
                    local left_cell = grid[nn]
                    table.insert(tempCells,nn)
                    local validOptions = {}
                    for i = 1, #left_cell.options do
                        local option = left_cell.options[i]
                        local valid =  wfc.rules5[option][2]; --2 -> right
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

    local arr = {}

    for j = 0, dimy-1 do
        arr[j+1] = {}
        for i = 0, dimx-1 do
            local index = i + j * dimx
            local cell = grid[index+1]
            arr[j+1][i+1] = cell.options[1]
        end
    end
    if info then
        print("wfc.rand5()")
        print("dimx = ",dimx)
        print("dimy = ",dimy)
        print(stopcounter .." cicles calculated")
        wfc.error5(grid)
    end
    return arr
end

return wfc
