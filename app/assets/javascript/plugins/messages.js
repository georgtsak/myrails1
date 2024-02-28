document.addEventListener("turbo:before-fetch-response", function (e) {
    if (e.target.id === 'messageform') {
        $(e.target).trigger('reset')
        sleep(400).then(() => {
            if ($('.messagescontainer').length > 0) {
                $('.messagescontainer').scrollTop($('.messagescontainer')[0].scrollHeight)
            }
        })
    }
})

$(window).on('resize', function() {
    $('.messagescontainer').height($(window).height() - 300)
    if ($('.messagescontainer').length > 0) {
        $('.messagescontainer').scrollTop($('.messagescontainer')[0].scrollHeight)
    }
})

$(document).on('turbo:load', function() {
    $('.messagescontainer').height($(window).height() - 300)
    if ($('.messagescontainer').length > 0) {
        $('.messagescontainer').scrollTop($('.messagescontainer')[0].scrollHeight)
    }
})

function updateConversation(conversation, message, user) {
    request = $.ajax({
        url: "/messages/" + message.id,
        type: "GET"
    })

    request.done(function (response, textStatus, jqXHR){
        Turbo.renderStreamMessage(response)
        if (message.users_id !== parseInt(getCookie('username'))) {
            showNotification('New message!', message.content.substring(0, 40), 'message_notification_' + message.id)
        }
    })
}