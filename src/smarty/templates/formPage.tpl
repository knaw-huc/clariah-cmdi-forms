<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8">
        <title>{$title}</title>
        <link rel="stylesheet" href="css/style.css" type="text/css" />
        <link rel="stylesheet" href="css/ccfstyle.css" type="text/css" />
        <link rel="stylesheet" href="css/autocomplete.css" type="text/css" />
        <script type="text/javascript" src="{$home_path}js/lib/jquery-3.2.1.min.js"></script>
        <script type="text/javascript" src="{$home_path}js/lib/jquery.autocomplete.js"></script>
        <script type="text/javascript" src="{$home_path}js/config/ccf_config{if !isset($lang)}_en{else}_{$lang}{/if}.js"></script>
        <script type="text/javascript" src="{$home_path}js/src/ccfparser.js"></script>
        <script type="text/javascript" src="{$home_path}js/src/ccforms.js"></script>
        <script>
            obj = {$json};
            $('document').ready(function(){literal}{{/literal}
            setEvents();
            formBuilder.start(obj);
            {literal}}{/literal});
        </script>
    </head>
    <body>
        <div id="wrapper">
        <div id="header">
            CLARIAH CMDI Forms
        </div>
        <div id="user">Rob Zeeman</div>
        <div id="homeBtn"></div>
        <div id="content">
            {block name="content"}<div id="ccform"></div>{/block}
        </div>
        </div>
    </body>
</html>
