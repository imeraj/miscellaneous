// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket} from "phoenix"

// HelloSocketsWeb.AuthSocket verifies a signed Phoenix.Token in the socket
// params. This token is for local development only; generate a fresh one with:
//
//   MIX_ENV=dev mix run -e 'IO.puts Phoenix.Token.sign(HelloSocketsWeb.Endpoint, "salt identifier", 1)'
//
// In a real app, have your auth layer provide the token (e.g. window.userToken).
let socket = new Socket("/socket", {params: {token: window.authToken}})
socket.connect()

// Join the lobby channel. The auth token travels with the socket connection,
// so the channel join payload can stay empty.
let channel = socket.channel("ping:1", {})
channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.error("Unable to join", resp) })

console.log("send ping")
channel.push("ping")
  .receive("ok", resp => { console.log("receive", resp.ping) })

console.log("send pong")
channel.push("pong")
  .receive("ok", resp => { console.error("won't happen") })
  .receive("error", resp => { console.error("won't happen yet") })
  .receive("timeout", resp => { console.error("pong message timeout", resp) })

channel.push("pong", {error: true})
  .receive("error", resp => { console.error("pong error", resp) })

channel.on("send_ping", (payload) => {
  console.log("ping requested", payload)
  channel.push("ping")
    .receive("ok", resp => { console.log("ping:", resp.ping) })
})

export default socket
