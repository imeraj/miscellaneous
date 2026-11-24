// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket} from "phoenix"

// And connect to the path in "lib/hello_sockets_web/endpoint.ex". We pass the
// token for authentication.
//
// Read the [`Using Token Authentication`](https://phoenix.hexdocs.pm/channels.html#using-token-authentication)
// section to see how the token should be used.
let socket = new Socket("/user_socket", {authToken: window.userToken})
socket.connect()

let dedupeChannel = socket.channel("dupe", {})

dedupeChannel.on("number", (payload) => {
  console.log("new number received", payload)  
})

dedupeChannel.join()

// Now that you are connected, you can join channels with a topic.
// Let's assume you have a channel with a topic named `room` and the
// subtopic is its id - in this case 42:
// let channel = socket.channel("ping:lobby", {})
// channel.join()
  // .receive("ok", resp => { console.log("Joined successfully", resp) })
  // .receive("error", resp => { console.log("Unable to join", resp) })

// console.log("send ping")
// channel.push("ping")
  // .receive("ok", resp => { console.log("receive", resp.ping) })

// console.log("send pong")
// channel.push("pong") 
  // .receive("ok", resp => { console.log("won't happen") })
  // .receive("error", resp => {console.error("won't happen yet")})
  // .receive("timeout", resp => {console.error("pong message timeout", resp)})

// channel.push("pong", {error: true})
  // .receive("error", resp => {console.log("pong error", resp)})
  
// channel.on("send_ping", (payload) => {
  // console.log("ping requested", payload)
  // channel.push("ping")
    // .receive("ok", resp => {console.log("ping:", resp.ping)})
// })  

export default socket
