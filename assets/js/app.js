// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

let Hooks = {}
Hooks.RoomMessages = {
  mounted() {
    // console.log("mounted")
    this.el.scrollTop = this.el.scrollHeight
  },
  updated() {
    // console.log("updated")
    this.el.scrollTop = this.el.scrollHeight
  }
}

// Enable connecting to a LiveView socket
import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})
liveSocket.connect()

// Import local files
//
// Local files can be imported directly using relative paths, for example:
