$(window).on('load', function() {
    $(".select-tags").select2({
        tags: true
    })

    $(".select-multiple").select2({
        multiple: true
    })

    subscribeForNotifications()
});