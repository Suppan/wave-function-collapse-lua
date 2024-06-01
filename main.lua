require 'help-functions'

local ps2pdf_path = "/usr/local/bin/ps2pdf"
local r = os.time() -- to lock: set here random seed (ut)
print("random seed = " .. r)
math.randomseed(r)


local dimx = 15
local dimy = 15
local info = true

local arr = wfc.rand5(dimx,dimy,info)

--wfc.print(arr)
wfc.show5(arr,ps2pdf_path)
