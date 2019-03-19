function setEvents() {
    var home = 'http://localhost/ccf';

    $("#profileDataNavigator li").on("click", function () {
        if (!$(this).hasClass("profileDataActiveTab"))
        {
            hideButtons();
            hideDetails();
            $(this).addClass("profileDataActiveTab");

            switch ($(this).attr('id'))
            {
                case 'profileXMLTab':
                    $('#profileXML').removeClass('noView');
                    break;
                case 'profileJSONTab':
                    $('#profileJSON').removeClass('noView');
                    break;
                case 'profileTweakTab':
                    $('#tweakXML').removeClass('noView');
                    break;
                case 'profileRecordsTab':
                    $('#metadataRecs').removeClass('noView');
                    break;
            }
        }
    });

    $("#homeBtn").hover(function () {
        $("#homeBtn").css('cursor', 'pointer');
    }).click(function () {
        window.location = home;
    });

    $("#profileDataNavigator li").each(function () {
        $(this).hover(function () {
            $(this).css('cursor', 'pointer');
        });
    });

}

function hideButtons() {
    $("#profileDataNavigator li").each(function () {
        if ($(this).hasClass("profileDataActiveTab"))
        {
            $(this).removeClass("profileDataActiveTab");
        }
    });
}

function hideDetails() {
    $("#profileDetails div").each(function () {
        if (!$(this).hasClass("noView"))
        {
            $(this).addClass("noView");
        }
    });
}

