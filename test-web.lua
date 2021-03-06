local createServer = require('continuable').tcp.createServer
local web = require('web')

local app = require('web-router')

-- Write a simple web app
local app = function (req, res)
  res(404, {
    ["Content-Type"] = "text/plain"
  }, "Not Found\n")
end

app = require('web-router')(app, function (router)

  router.get("/greet/:name", function (req, res)
    return res(200, {
      ["Content-Type"] = "text/plain"
    }, "Hello " .. req.params.name .. "\n")
  end)

end)

-- Wrap it in some useful middleware modules
app = require('web-static')(app, {
  root = __dirname .. "/public",
  index = "index.html",
  autoIndex = true
})
app = require('web-log')(app)
app = require('web-autoheaders')(app)

local host = process.env.IP or process.env.OPENSHIFT_INTERNAL_IP or "0.0.0.0"
local port = process.env.PORT or 8080
-- Serve the HTTP web app on a TCP server
createServer(host, port, web.socketHandler(app))
