local d=require("dumphash")

function parsekkvml(current,line)
	local v_or_k,previous_k
	for item in string.gmatch(line,"(%g+)") do
		if previous_k
		then
			current[previous_k]={}
			current=current[previous_k]
		end
		previous_k=v_or_k
		v_or_k=item
	end
	current[previous_k]=v_or_k
end

local h={}
parsekkvml(h,"a:b 20")
parsekkvml(h,"a:c 20")
parsekkvml(h,"a:d 20")
parsekkvml(h,"a:e zzz 20")
d.dumphash(h)

local vmstat={}
for l in io.lines("/proc/vmstat")
do
	parsekkvml(vmstat,l)
end
d.dumphash(vmstat)
