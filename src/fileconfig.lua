local fm = {}
local files = {}

-- keep files
files["app/assets/.keep"] = ""
files["app/helpers/.keep"] = ""
files["logs/.keep"] = ""

files["app/scripts/pages_controller.lua"] = ""
files["app/views/pages/home.html.el"] =
    '<!DOCTYPE html>\n<html lang="en">\n\t<head>\n\t\t<meta charset="UTF-8">\n\t\t<meta http-equiv="X-UA-Compatible" content="IE=edge">\n\t\t<meta name="viewport" content="width=device-width, initial-scale=1.0">\n\t\t<title>Live Lua!</title>\n\t\t<style>\n\t\t\t* {\n\t\t\t\tmargin: 0;\n\t\t\t\tfont-family: Arial, Helvetica, sans-serif;\n\t\t\t}\n\t\t</style>\n\t</head>\n\t<body>\n\t\t<div style="width:100%;height:100%;background-color:#000;position:absolute;margin:0;">\n\t\t\t<h1 style="position:absolute;width:fit-content;left:50%;transform:translateX(-50%);color:#fff;top:7.5%;">\n\t\t\t\t<!= I18n("defaultapp.pages.home.top") !>\n\t\t\t</h1>\n\t\t\t<img src="https://github.com/Dollor-Lua/LuaS/blob/main/LuaSLogo.png?raw=true" style="top:45%;height:50%;width:fit-content;position:absolute;left:50%;transform:translate(-50%, -50%);">\n\t\t\t<h1 style="color:#fff;top:85%;left:50%;transform:translate(-50%, -100%);position:absolute;">\n\t\t\t\t<!= I18n("defaultapp.pages.home.bottom") !>\n\t\t\t</h1>\n\t\t</div>\n\t</body>\n</html>'

files["config/locales/supported.lua"] = "-- Capitalization matters!\nreturn {'en-US', 'fr-FR'}"
files["config/locales/I18n.lua"] =
    'local I18n = {}\nI18n.languageCode = "en-US"\nI18n._defaultLang = "en-US"\nI18n.supported = require("config.locales.supported")\n\n-- split function\nlocal split = function(string, delim)\n\tdelim = delim or "%s"\n\tif delim == "" then\n\t\tdelim = "%s"\n\tend\n\n\tlocal t = {}\n\tfor str in string.gmatch(string .. delim, "(.-)" .. delim) do\n\t\ttable.insert(t, str)\n\tend\n\n\treturn t\nend\n\nI18n.parse = function(formatString, text)\n\tlocal language = I18n.__183324__(text, I18n.getLanguageCode()) or text\n\n\tif formatString then\n\t\treturn table.concat(split(formatString, "&s"), language)\n\tend\n\n\treturn language\nend\n\nI18n.getLanguageCode = function()\n\treturn I18n.languageCode\nend\nI18n.setLanguageCode = function(language)\n\tfor _, lang in pairs(I18n.supported) do\n\t\tif lang:lower() == language:lower() then\n\t\t\tI18n.languageCode = lang\n\t\t\tbreak\n\t\tend\n\tend\n\n\treturn I18n.languageCode:lower() == language:lower()\nend\n\nI18n.__183324__ = function(text, lang)\n\tlocal lang = require("config.locales.languages." .. lang .. ".lua") or\n\t\t\t\t\trequire("config.locales.languages" .. I18n._defaultLang .. ".lua")\n\n\tif lang then\n\t\treturn lang[text] or text\n\tend\n\t\treturn text\nend'

files["config/locales/languages/en-US.lua"] =
    'return {\n\t["defaultapp.pages.home.top"] = "Woo! You\'ve got Live Lua up and running!",\n\t["defaultapp.pages.home.bottom"] = "Get started by editting views/pages/home.html.el"\n}'
files["config/locales/languages/fr-FR.lua"] =
    'return {\n\t["defaultapp.pages.home.top"] = "Bon travail! On dirait que Live Lua est opérationnel!",\n\t["defaultapp.pages.home.bottom"] = "Commencez par éditer views/pages/home.html.el"\n}'

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
