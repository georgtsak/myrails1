function subscribeForNotifications() {
    notificationsSocket = new WebSocket('ws://localhost:3000/cable');
    notificationsSocket.onopen = function(event) {
        const msg = {
            command: 'subscribe',
            identifier: JSON.stringify({
                channel: 'NotificationsChannel'
            }),
        };
        notificationsSocket.send(JSON.stringify(msg));
    };
    notificationsSocket.onclose = function(event) {
        console.log('Notifications socket is closed.');
    };
    notificationsSocket.onmessage = function(event) {
        const response = event.data
        const msg = JSON.parse(response)
        
        // Ignores pings.
        if (msg.type === "ping") {
            return;
        }
        
        if (msg.message) {
            if (msg.message.type === 'message') {
                updateConversation(msg.message.conversation, msg.message.message)
            }
        }
    };
    notificationsSocket.onerror = function(error) {
        console.log('Notifications socket crashed.');
        console.log(error);
    };
}