default["gc-base"]["user"] = "root"
default["gc-base"]["group"] = "root"

if node["gc-base"]["user"] == "root"
	default["gc-base"]["home_dir"] = "/root"
else
	default["gc-base"]["home_dir"] = "/home/#{node["gc-base"]["user"]}"
end