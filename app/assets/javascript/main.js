$(window).on('load', function() {
    subscribeForNotifications()
})

$(document).on('turbo:load', function() {
    $(".select-tags").select2({
        tags: true
    })

    $(".select-multiple").select2({
        multiple: true
    })
})