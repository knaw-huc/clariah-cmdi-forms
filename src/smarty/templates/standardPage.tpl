<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">
<html lang="en">
    <head>
        <meta http-equiv="content-type" content="text/html; charset=utf-8">
        <title>{$title}</title>
        <link rel="stylesheet" href="css/style.css" type="text/css" />
        <link rel="stylesheet" href="{$home_path}js/lib/jquery-ui/jquery-ui.css"/>
        <script type="text/javascript" src="{$home_path}js/lib/jquery-3.2.1.min.js"></script>
        <script type="text/javascript" src="{$home_path}js/lib/jquery-3.2.1.min.js"></script>
        <script type="text/javascript" src="{$home_path}js/lib/jquery-ui/jquery-ui.js"></script>
        <script type="text/javascript" src="{$home_path}js/src/ccforms.js"></script>
        <script>
            $('document').ready(function(){literal}{{/literal}
            setEvents();{literal}}{/literal});
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
            {block name="content"}Content{/block}
        </div>
        </div>
    </body>
</html>
