$(window).on('load', function() {
    $(".select-tags").select2({
        tags: true
    });

    $('#messagescontainer').height($(window).height() - 300)
});