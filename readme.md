Micro Basolato
===

This is a micro web framework to develop [Basolato](https://github.com/itsumura-h/nim-basolato) based on [asynchttpserver](https://nim-lang.org/docs/asynchttpserver.html)

## exmaple

controller.nim
```nim
import std/asyncdispatch
import std/asynchttpserver
import micro_basolato

proc index*(request:Request): Future[Response] {.async.} =
  return render("index")

proc show*(request:Request): Future[Response] {.async.} =
  return render("show")
```

main.nim
```nim
import std/asynchttpserver
import micro_basolato
import ./controller

let routes = @[
  Route.new(HttpGet, "/", controller.index),
  Route.new(HttpGet, "/show", controller.show),
]

serve(routes, host="0.0.0.0", port=9000, debug=true)
```
