<?php

require(dirname(__FILE__) . '/config/common.inc.php');
require(dirname(__FILE__) . '/config/ccf.config.inc.php');

$uploads_dir = CMDI_UPLOAD_PATH;
$records_dir = CMDI_RECORD_PATH . "resources/";

if (isset($_FILES['file']) && ($_FILES['file']['error'] == UPLOAD_ERR_OK)) {
    $newPath = "$uploads_dir/" . basename($_FILES['file']['name']);
    if (move_uploaded_file($_FILES['file']['tmp_name'], $newPath)) {
        header("HTTP/1.0 200 OK");
        echo "OK";
    } else {
        header("HTTP/1.0 404 Not Found");
        echo 'Error!';
    }
} else {
    header("HTTP/1.0 404 Not Found");
    echo 'Error!';
}



/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

