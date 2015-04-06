require "cord"
require "storm" 
require "svcd"


SVCD.init(nil,function()
    print("listener init")
end)

print "yo"

cord.enter_loop()
