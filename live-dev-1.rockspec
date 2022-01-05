package = "Live"
version = "dev-1"
source = {
   url = "git+https://github.com/Dollor-Lua/LiveLua.git"
}
description = {
   summary = "A server-sided web application full-stack framework written in Lua.",
   detailed = [[
A server-sided web application full-stack framework written in Lua. Based on rails, Live Lua is a model–view–controller framework, providing default structures for a web service, and web pages.
]],
   homepage = "https://github.com/Dollor-Lua/LiveLua",
   license = "MIT"
}
build = {
   type = "builtin",
   modules = {
      main = "src/main.lua",
      ["server.request"] = "src/server/request.lua",
      ["server.response"] = "src/server/response.lua",
      ["server.server"] = "src/server/server.lua",
      ["server.serverHandler"] = "src/server/serverHandler.lua",
      ["utils.stringUtils"] = "src/utils/stringUtils.lua"
   }
}
