#!/usr/bin/lua
local data={}
local config={}
local phase=data
local datatype="bytes"

--- Start arguments
-- Which phase to use
if arg[1]== "config"
then
        phase=config
end
-- which output
datatype=string.match(arg[0],"_([a-z]+)$") or "bytes"

--- Generic functions
-- printf, short for..
function printf(fmt,...)
        io.write(string.format(fmt,...))
end
-- split a line into fields
function split(f,l)
        local v={}
        local fn=1
        for d in string.gmatch(l," (%S+)") do
                v[f[fn]]=d
                fn = fn+1
        end
        return v
end
-- fillout replacement
function fillout(t,s)
        return (t:gsub("${([%a]+)}", function(m) return s[m] or m end))
end

function fwrite(t,s)
        io.write(fillout(t,s))
end
--- Specific
-- Normalice ifname and strip :
function normalizeif(s)
        s=string.gsub(s,"[#.]","_")
        s=string.gsub(s,":","")
        return s
end

-- All fields
local fields = {
        "interface","rbytes","rpackets","rerrs","rdrop","rfifo","rframe","rcompressed","rmulticast","tbytes","tpackets","terrs","tdrop","tfifo","tcolls","tcarrier","tcompressed","bogus"
}
-- All printable fields for misc datatype
local miscfields = {
        "rerrs","rdrop","rfifo","rframe","rcompressed","rmulticast","terrs","tdrop","tfifo","tcolls","tcarrier","tcompressed"
}

function config.pre(datatype)
        printf(
[[graph_title Network Interfaces (%s)
graph_args --base 1000
graph_vlabel bits in (-) / out (+)
graph_category network
]],datatype)
end

function config.misc(s)
        for _,v in pairs(miscfields) do
                fwrite([[
data_${v}_${interface}.label ${interface}_${v}
data_${v}_${interface}.type COUNTER
data_${v}_${interface}.max 1300000000
]],
{ v=v, interface=s.interface})
        end
end
function config.packets(stats)
        fwrite([[
data_in_${interface}.label i_${interface}
data_in_${interface}.type COUNTER
data_in_${interface}.graph no
data_in_${interface}.max 1300000000
data_out_${interface}.label ${interface}
data_out_${interface}.type COUNTER
data_out_${interface}.negative data_in_${interface}
data_out_${interface}.max 1300000000
]],stats)
end
config.bytes=config.packets

function data.pre(datatype)
end
function data.packets(stats)
        fwrite([[
data_in_${interface}.value ${rpackets}
data_out_${interface}.value ${tpackets}
]],stats)
end
function data.bytes(stats)
        fwrite([[
data_in_${interface}.value ${rbytes}
data_out_${interface}.value ${tbytes}
]],stats)
end
function data.misc(s)
        for _,v in pairs(miscfields) do
                printf("data_%s_%s.value %s\n",v,s.interface,s[v])
        end
end

phase.pre(datatype)

local linenr=0
for l in io.lines("/proc/net/dev")
do
        linenr=linenr+1
        if(linenr>2) then
                local v=split(fields,l)
                v.interface=normalizeif(v.interface)
                phase[datatype](v)
        end
end
return(0)

