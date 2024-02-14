import consumer from "./consumer"

consumer.subscriptions.create({ channel: "MessagesChannel", room: "Best Room" })