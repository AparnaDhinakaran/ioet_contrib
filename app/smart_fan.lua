require "cord"
require "storm" 

print ("Button test ")
function onconnect(state)
   if tmrhandle ~= nil then
       storm.os.cancel(tmrhandle)
       tmrhandle = nil
   end
   if state == 1 then
       storm.os.invokePeriodically(1*storm.os.SECOND, function()
           tmrhandle = storm.bl.notify(char_handle, 
              string.format("Time: %d", storm.os.now(storm.os.SHIFT_16)))
       end)
   end
end

function fanControl(state)
	storm.io.set_mode(storm.io.OUTPUT,  storm.io.D11)
	storm.io.set_mode(storm.io.OUTPUT,  storm.io.D10)
	storm.io.set_mode(storm.io.OUTPUT,  storm.io.D9)

	storm.io.set(0, storm.io.D11)
	storm.io.set(0, storm.io.D10)
	storm.io.set(0, storm.io.D9)
	if state == "low" then 
		storm.io.set(1, storm.io.D9)
	end
	if state == "med" then 
		storm.io.set(1, storm.io.D10)
	end
	if state == "high" then 
		storm.io.set(1, storm.io.D11)
	end 	
end 
	
	
fanControl("high")

storm.bl.enable("unused", onconnect, function()
   local svc_handle = storm.bl.addservice(0x1337)
   char_handle = storm.bl.addcharacteristic(svc_handle, 0x1338, function(x)
       print ("received: ",x)
   end)
end)

storm.bl.enable("unused", fanControl, function()
   local svc_handle = storm.bl.addservice(0x1345)
   char_handle = storm.bl.addcharacteristic(svc_handle, 0x1345, function(x)
	print ("recieved: ",x)
   end)
end)

-- set buttons as outputs
-- storm.io.set_mode(storm.io.OUTPUT,  storm.io.D11)

-- state = 1 
-- storm.io.set(1, storm.io.D11)
-- this is a hack, poll button state every 50ms
--storm.os.invokePeriodically(3*storm.os.SECOND, function ()
--    -- get button states
--    if state == 0 then 
--	storm.io.set(1, storm.io.D11)
--	state = 1
--    end 
--    if state == 1 then
--	storm.io.set(0, storm.io.D11)
--   	state = 0
--    end 
--end)

print ("End")
cord.enter_loop()
