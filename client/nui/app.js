var camera = false;

function setLocation(location) {
    $(".street-time > p:first-child").text("Location: " + location);
}

function open(image) {
    if (!camera) {
        $('.container').fadeIn('slow');
        $('.camera').fadeIn('slow');
        $('.street-time').fadeIn('slow');
        $('<img  src='+image+' style = "width:100%; height: 100%;">').appendTo('.camera')
        camera = true
    }
}

function close() {
    if (camera) {
        $('.container').fadeOut('fast');
        $('.camera').fadeOut('fast');
        $('.camera').html("");
        $('.street-time').fadeOut('fast');
        camera = false
        $.post(`https://${GetParentResourceName()}/close`)
    }
}

$(document).ready(function() {

    window.addEventListener("message", function (event) {
    switch (event.data.action) {
        case "Open":
            open(event.data.image);
            break;
        case "SetLocation":
            setLocation(event.data.location);
            break;
        case "showOverlay":
            document.getElementById("camera-overlay").classList.remove("hide");
            break;
        case "hideOverlay":
            document.getElementById("camera-overlay").classList.add("hide");
            break;
        }
    });

    document.onkeydown = function (event) {
        if (event.repeat) {
          return;
        }
        switch (event.key) {
          case "Escape":
            close();
            break;
        }
    };
})