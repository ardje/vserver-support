local M={}
function M.dumphash(arg,prefix,visited)
	if visited == nil
	then
		visited={arg}
	end
	prefix = prefix or ""
	for k,v in pairs(arg)
	do
		if  type(v) == "table" and visited[v]==nil
		then
			print(prefix .. k .. "+" )
			visited[v]=1
			M.dumphash(v,prefix .. k .. ".",visited)
		else
			print(prefix .. k, v)
		end
	end
end

return M
