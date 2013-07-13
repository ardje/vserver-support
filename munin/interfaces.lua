#!/usr/bin/lua
local mh=require("munin.helper")
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

-- All fields
local fields = {
        "interface","rbytes","rpackets","rerrs","rdrop","rfifo","rframe","rcompressed","rmulticast","tbytes","tpackets","terrs","tdrop","tfifo","tcolls","tcarrier","tcompressed","bogus"
}
-- All printable fields for misc datatype
local miscfields = {
        "rerrs","rdrop","rfifo","rframe","rcompressed","rmulticast","terrs","tdrop","tfifo","tcolls","tcarrier","tcompressed"
}

-- which output
for _,datatype in ipairs({ "bytes", "packets", "misc" })
do
mh.printf([[
multigraph interfaces_%s
]],datatype)

function config.pre(datatype)
        mh.fwrite( [[
graph_title Network Interfaces (${datatype})
graph_args --base 1000
graph_vlabel bits in (-) / out (+)
graph_category network
]],{ datatype=datatype })
end

function config.misc(s)
        for _,v in pairs(miscfields) do
                mh.fwrite([[
data_${v}_${interface}.label ${interface}_${v}
data_${v}_${interface}.type COUNTER
data_${v}_${interface}.max 1300000000
]],
{ v=v, interface=s.interface})
        end
end
function config.packets(stats)
        mh.fwrite([[
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
        mh.fwrite([[
data_in_${interface}.value ${rpackets}
data_out_${interface}.value ${tpackets}
]],stats)
end
function data.bytes(stats)
        mh.fwrite([[
data_in_${interface}.value ${rbytes}
data_out_${interface}.value ${tbytes}
]],stats)
end
function data.misc(s)
        for _,v in pairs(miscfields) do
                mh.printf("data_%s_%s.value %s\n",v,s.interface,s[v])
        end
end

phase.pre(datatype)

local linenr=0
for l in io.lines("/proc/net/dev")
do
        linenr=linenr+1
        if(linenr>2) then
                local v=mh.split(fields,l)
                v.interface=mh.normalizeif(v.interface)
                phase[datatype](v)
        end
end
mh.printf("\n")

end
return(0)

