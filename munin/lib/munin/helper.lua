local m={}
--- Generic functions
-- printf, short for..
function m.printf(fmt,...)
        io.write(string.format(fmt,...))
end
-- split a line into fields
function m.split(f,l)
        local v={}
        local fn=1
        for d in string.gmatch(l," (%S+)") do
                v[f[fn]]=d
                fn = fn+1
        end
        return v
end
-- fillout replacement
function m.fillout(t,s)
        return (t:gsub("${([%a]+)}", function(m) return s[m] or m end))
end

function m.fwrite(t,s)
        io.write(m.fillout(t,s))
end
--- Specific
-- Normalice ifname and strip :
function m.normalizeif(s)
        s=string.gsub(s,"[#.]","_")
        s=string.gsub(s,":","")
        return s
end

function m.readfile(s)
	local f=assert(io.open(s,"r"))
	local v=f:read("*a")	
	f:close()
	return v
end
return m


