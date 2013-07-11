local h=io.popen("ls -l","r")
for l in h:lines()
do
	print("B",l)
end
