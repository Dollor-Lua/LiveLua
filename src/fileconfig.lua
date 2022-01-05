local fm = {}
local files = {}

-- keep files
files["app/assets/.keep"] = ""
files["app/helpers/.keep"] = ""
files["logs/.keep"] = ""

files["app/scripts/pages_controller.lua"] = ""
files["app/views/pages/home.html.el"] = ""

files["config/locales/I18n.lua"] = ""
files["config/locales/en-US.lua"] = ""

files["config/etc/webpacker_config.lua"] = ""

files["config/etc/logger.lua"] = ""
files["config/etc/backtrace_silencer.lua"] = ""

files["config/etc/assets.lua"] = ""

files["config/environment.lua"] = ""
files["config/routes.lua"] = ""

files["config/app.lua"] = ""
files["config/boot.lua"] = ""

files["public/404.html.el"] = ""
files["public/422.html.el"] = ""
files["public/500.html.el"] = ""

files["public/favicon.ico"] = ""

files["public/robots.txt"] =
    "# See http://www.robotstxt.org/robotstxt.html for documentation on how to use the robots.txt file\n#\n# To ban all spiders from the entire site uncomment the next two lines:\n# User-agent: *\n# Disallow: /\n"

files["bin/luaw"] = ""
files["bin/luaw.bat"] = ""

files["Whirls.rdn"] = ""
files["Whirls.lock"] = ""
files["Accessor"] = ""
files["README.md"] =
    "# Live Lua!\nWhat to add here:\n - Information about your project\n - How to contribute\n - How to submit a bug report\n"
files["AUTHORS"] = ""
files["package.lua"] =
    "return {\n\t['name'] = '',\n\t['license'] = 'MIT',\n\t['private'] = true,\n\t['description'] = '',\n\t['author'] = {\n\t\t['email'] = '',\n\t\t['repository'] = ''\n\t}\n}\n"
files["extras.yml"] = ""

fm["files"] = files

fm["webpacker"] = {
    ["webpacker.core"] = {"whirl_modules/webpacker/webpacker.lua",
                          [[package.path=package.path..";./?.lua"local a=require("fs")local b={}b.read=function(c)local d=io.open(c,"r")local e=d:read()d:close()return e end;b.compile=function(f)end;return b]]},
    ["webpacker.fs"] = {"whirl_modules/webpacker/fs.lua",
                        [[local a=require('path')local b={}b.cwd=io.popen("cd","r"):read("l")b.isDir=function(a)local c=io.open(a,"r")local d,e,f=c:read(1)c:close()return f==21 end;b.getAllFilesInDir=function(g)local h='dir "'..g..'" /b /ad && dir "'..g..'" /b'if package.config:sub(1,1)=="/"then h='ls -A "'..g..'"'end;local i={}for g in io.popen(h):lines()do table.insert(i,g)end;local j={}for k in i do if b.isDir(a.join(b.cwd,k))then local l=b.getAllFilesInDir(a.join(b.cwd,k))for c in l do table.insert(j,c)end else table.insert(j,a.join(b.cwd,k))end end;return j end;return b]]},
    ["webpacker.path"] = {"whirl_modules/webpacker/path.lua",
                          [[local a=require("src.utils.stringUtils")local b={}local c=package.config:sub(1,1)b.normalize=function(b)local d=table.concat(a.split(table.concat(a.split(b,"/"),"\\"),"\\"),c)local e={}for f,g in pairs(a.split(d,c))do if g~=""then table.insert(e,g)end end;return table.concat(e,c)end;b.delimeter=c=="/"and":"or";"b.separator=c;b.join=function(...)local h={}for f,i in pairs({...})do for f,j in pairs(a.split(b.normalize(i),c))do if j~=""and j~=" "then table.insert(h,j)end end end;return table.concat(h,c)end;return b]]}
}

return fm
