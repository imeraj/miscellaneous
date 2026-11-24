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
let socket = new Socket("/auth_socket", {params: {token: window.authToken}})
socket.connect()

let recurringChannel = socket.channel("recurring", {})

recurringChannel.on("new_token", (payload) => {
  console.log("received new auth token", payload)  
})

recurringChannel.join()

export default socket
