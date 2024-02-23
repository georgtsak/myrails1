import CableReady from "cable_ready";
import consumer from "./consumer";

consumer.subscriptions.create({ 
  channel: "NotificationsChannel",
  
  connected: function() {
    console.log('Connected')
  },

  disconnected: function() {
    console.log('Disconnected')
  },

  received: function(data) {
    console.log(data);
    if (data.cableReady) CableReady.perform(data.operations);
    $("#notifications").prepend(data.html);
  }
})