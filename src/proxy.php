<?php
$ch = curl_init("https://vocabularies.clarin.eu/clavas/public/api/autocomplete/" . $_GET["q"]);
curl_setopt($ch, CURLOPT_HEADER, 0);
curl_setopt($ch, CURLOPT_HTTPHEADER, array('Content-type: application/text'));
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$json = curl_exec($ch);
//echo $json;
$json = json_decode($json);
if (!$json) {
    $json = "";
}
$retArray = array("query" => "Unit", "suggestions" => $json);
echo json_encode($retArray);
curl_close($ch);