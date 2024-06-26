import std/asynchttpserver
import ../src/micro_basolato
import ./controller

let routes = @[
  Route.new(HttpGet, "/", controller.index),
  Route.new(HttpGet, "/show", controller.show),
]

serve(routes, host="0.0.0.0", port=9000, debug=true)
