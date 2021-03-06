require "cord"
require "storm" 

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

storm.io.set_mode(storm.io.OUTPUT,  storm.io.D2)
storm.io.set_mode(storm.io.OUTPUT,  storm.io.D3)
storm.io.set_mode(storm.io.OUTPUT,  storm.io.D4)

function fanControl(state)
    storm.io.set(0, storm.io.D2)
    storm.io.set(0, storm.io.D3)
    storm.io.set(0, storm.io.D4)

	if state == "low" then 
		storm.io.set(1, storm.io.D2)
        print("turning on d2")
	end
	if state == "med" then 
		storm.io.set(1, storm.io.D3)
        print("turning on d3")
	end
	if state == "high" then 
		storm.io.set(1, storm.io.D4)
        print("turning on d4")
	end 	
end 

counter=0
storm.os.invokePeriodically(2*storm.os.SECOND,function()
    counter=counter+1
    print(counter%4)
    if counter%4==0 then
        fanControl("off")
    elseif counter%4==1 then
        fanControl("low")
    elseif counter%4==2 then
        fanControl("med")
    else
        fanControl("high")
    end	
end)



storm.bl.enable("unused", onconnect, function()
   local svc_handle = storm.bl.addservice(0x1337)
   char_handle = storm.bl.addcharacteristic(svc_handle, 0x1338, function(x)
       print ("received: ",x)
   end)

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
