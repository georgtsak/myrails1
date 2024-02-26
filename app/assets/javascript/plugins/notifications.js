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
            } else if (msg.message.type === 'friend') {
                switch (msg.message.subtype) {
                    case 'create':
                        showNotification('Success', 'Friend request succesfully sent!', 'friend_notification_')
                        break;

                    case 'deny':
                        showNotification('Success', 'Friend request succesfully denied!', 'friend_notification_')
                        break;

                    case 'accept':
                        showNotification('Success', 'Friend request succesfully accepted!', 'friend_notification_')
                        break;

                    case 'not_exists':
                        showNotification('Failure', 'Friend request does not exists!', 'friend_notification_')
                        break;
                }
            }
        }
    };
    notificationsSocket.onerror = function(error) {
        console.log('Notifications socket crashed.');
        console.log(error);
    };
}

function showNotification(notificationTitle, notificationText, notificationID) {
    let element = $('<div class="notifications-item" id="' + notificationID + '"><button class="notifications-item__close">x</button>'
    + '<div class="notifications-title">' + notificationTitle + '</div>' 
    + '<div class="notifications-content">' + notificationText + '</div>' 
    + '</div>')
    $('#notifications').append(element)

    sleep(4000).then(() => {
        element.remove()
    })

    $(notificationID + ' .notifications-item__close').on('click', function() {
        $(this).remove()
    })
}