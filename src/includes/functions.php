<?php

$smarty = new Mysmarty();
$db = new db();

function show_home() {
    global $db;
    global $smarty;

    $profiles = $db->getProfiles();
    $smarty->assign('profiles', $profiles);
    $smarty->assign('title', APPLICATION_NAME);
    $smarty->view('home');
}

function show_page($params) {
    global $db;
    
    switch ($params["page"]) {
        case "profile":
            if (isset($params["id"]) && ($profile = $db->getProfile($params["id"]))) {
                if (isset($params["state"])) {
                    show_profile($profile[0], $params["state"]);
                } else {
                    show_profile($profile[0]);
                }
            } else {
                show_home();
            }
            break;
        case "metadata":
            if (isset($params["id"]) && ($profile = $db->getProfileByMetaDataID($params["id"]))) {
                    show_metadata($profile[0]["name"], $profile[0]["language"], $params["id"]);
            } else {
                show_home();
            }
            break;
        case "new_rec":
            if (isset($params["profile"])) {
                add_record($params["profile"]);
            } else {
                show_home();
            }
            break;
        case "add_record":
            add_record();
            break;
        default:
            show_home();
    }
}

function add_record($profile) {
    global $db;
    global $smarty;
    
    //$profile = $_POST["profile_id"];
    $title = 'Another CMDI record';
    $md_id = $db->addRecord($title, $profile);
    $mapName = CMDI_RECORD_PATH . "md$md_id";
    error_log($mapName);
    create_map($mapName);
    create_map("$mapName/resources");
    create_map("$mapName/metadata");
    header("Location: " . BASE_URL . "index.php?page=metadata&id=$md_id");
}

//function new_rec($profile, $name) {
//    global $smarty;
//    $smarty->assign("profileName", $name);
//    $smarty->assign("profile_id", $profile);
//    $smarty->assign("date", date("Y-m-d"));
//    $smarty->view("newrecord");
    
//}

function show_profile($profile, $state = 'profile') {
    global $smarty;
    global $db;

    $smarty->configLoad(ROOT . 'config/my.conf', 'Tabs');
    $profileTab = $smarty->getConfigVars('profileTab');
    $tweakTab = $smarty->getConfigVars('tweakTab');
    $recordsTab = $smarty->getConfigVars('recordsTab');

    $parser = new Ccfparser();
    $profile["json"] = $parser->cmdi2json($profile["content"]);
    //$profile["parsed"] = $parser->parseTweak($profile["tweak"]);
    $mdRecords = $db->getMetadataRecords($profile["profile_id"]);

    $smarty->assign('profileTab', $profileTab);
    $smarty->assign('tweakTab', $tweakTab);
    $smarty->assign('recordsTab', $recordsTab);
    $smarty->assign('state', $state);
    $smarty->assign('records', $mdRecords);
    $smarty->assign('profile', $profile);
    $smarty->assign('title', 'CMDI profile');
    $smarty->view('profile');
}

function show_metadata($name, $language, $recID) {
    global $smarty;
    $_SESSION["rec_id"] = $recID;
    
    $errors = array();
    $cmdi = PROFILE_PATH . "$name.xml";
    $tweakFile = TWEAK_PATH . $name . "Tweak.xml";
    $tweaker = TWEAKER;
    $parser = new Ccfparser();
    $record = get_record_file($recID);
     $smarty->assign('lang', $language);
    if (!file_exists($cmdi)) {
        $errors[] = "Profile $name not found on disc!";
        show_errors($errors);
    } else {
        if (!file_exists($tweakFile)) {
            $json = $parser->parseTweak($cmdi, null, null, $record);
            $smarty->assign('title', 'CMDI Form');
            $smarty->assign('json', $json);
            $smarty->view('formPage');
        } else {
            if (!file_exists(TWEAKER)) {
                $errors[] = "Tweaker xslt not found on disc!";
                show_errors($errors);
            } else {
                $json = $parser->parseTweak($cmdi, $tweakFile, $tweaker, $record);
                if ($json) {
                    $smarty->assign('title', 'CMDI Form');
                    $smarty->assign('json', $json);
                    $smarty->view('formPage');
                } else {
                    $errors[] = "Error detected in xslt tranformation!";
                    show_errors($errors);
                }
            }
        }
    }
}

function get_record_file($id){
    $fileName = CMDI_RECORD_PATH . "md$id/metadata/record.cmdi";
    if (file_exists($fileName)){
        return $fileName;
    }else{
        return null;
    }
}

function show_errors($errors) {
    $this->smarty->assign('errors', $errors);
    $this->smarty->assign('title', 'Error!');
    $this->smarty->view('errors');
}

function create_map($filename) {
    if (!file_exists($filename)) {
        mkdir($filename);
    }
}
