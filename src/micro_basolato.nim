import std/asynchttpserver
import std/asyncdispatch


# ================================
# Response
# ================================
type Response* = object
  status*:int
  body*:string
  headers*:HttpHeaders


proc new*(_:type Response, status:int, body:string, headers:HttpHeaders):Response =
  return Response(
    status:status,
    body:body,
    headers:headers,
  )


proc render*(body:string, header=newHttpHeaders()):Response =
  return Response(
    status:200,
    body:body,
    headers:header
  )


# ================================
# Controller
# ================================
type Controller* = proc(req:Request):Future[Response] {.async, gcsafe.}


# ================================
# Route
# ================================
type Route* = object
  httpMethod*:HttpMethod
  path*:string
  controller*:Controller

proc new*(_:type Route, httpMethod:HttpMethod, path:string, controller:Controller):Route =
  return Route(
    httpMethod:httpMethod,
    path:path,
    controller:controller,
  )


proc asyncServe(routes:seq[Route], host:string, port:int, debug:bool) {.async.} =
  var server = newAsyncHttpServer(true, true)
  proc cb(req: Request) {.async, gcsafe.} =
    var response = Response(status:404, body:"", headers:newHttpHeaders())
    for route in routes:
      if req.url.path == route.path and req.reqMethod == route.httpMethod:
        response = await route.controller(req)
        if debug:
          echo response.status, " ", req.url.path

    req.respond(HttpCode(response.status), response.body, response.headers).await

  server.listen(Port(port), host)
  while true:
    if server.shouldAcceptRequest():
      await server.acceptRequest(cb)
    else:
      await sleepAsync(500)


proc serve*(routes:seq[Route], host="0.0.0.0", port=8000, debug=true) =
  asyncServe(routes, host, port, debug).waitFor()
