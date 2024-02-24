document.addEventListener("turbo:before-fetch-response", function (e) {
    if (e.target.id === 'messageform') {
        $(e.target).trigger('reset')
        sleep(250).then(() => {
            if ($('.messagescontainer').length > 0) {
                $('.messagescontainer').scrollTop($('.messagescontainer')[0].scrollHeight)
            }
        })
    }
})

const sleep = ms => new Promise(r => setTimeout(r, ms));

$(window).on('load', function() {
    $('.messagescontainer').height($(window).height() - 300)
    if ($('.messagescontainer').length > 0) {
        $('.messagescontainer').scrollTop($('.messagescontainer')[0].scrollHeight)
    }

    $('#sendMessage').on('submit', function(event) {
    event.preventDefault()

    const formValues = $('#sendMessage').serializeArray()
    let values = {}

    for (let i = 0; i < formValues.length; i++) {
        if (formValues[i].name === 'message[conversation_id]') {
        values['conversation'] = {}
        values.conversation.id = formValues[i].value
        } else if (formValues[i].name === 'message[content]') {
        values['message'] = {}
        values.message.content = formValues[i].value
        } else {
        values[formValues[i].name] = formValues[i].value
        }
    }

    request = $.ajax({
        url: "/messages/create",
        type: "POST",
        data: JSON.stringify(values),
        contentType: "application/json; charset=utf-8",
        headers: {
        "X-CSRF-Token": values['authenticity_token']
        },
        beforeSend(xhr) {
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
        }
    })

    request.done(function (response, textStatus, jqXHR){
        $('#sendMessage').trigger("reset")
    })
    })
})

function updateConversation(conversation, message) {
    console.log(conversation)
    console.log(message)
}