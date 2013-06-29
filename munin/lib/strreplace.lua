function fillout(t,s)
        return (t:gsub("${([%a]+)}", function(m) return s[m] or m end))
end

text=[[
zomaar een test voor ${naam} om te kijken
of dit test${je} werkt.
${poep}
]]
subst={ naam="fillout",je="meuh" }
print(fillout(text,subst))

