import std/asyncdispatch
import std/asynchttpserver
import ../src/micro_basolato

proc index*(request:Request): Future[Response] {.async.} =
  return render("index")

proc show*(request:Request): Future[Response] {.async.} =
  return render("show")
