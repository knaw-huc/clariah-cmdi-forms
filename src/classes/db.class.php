<?php

class db {

    var $con;

    function __construct() {
        $this->con = new mysqli(DB_SERVER, DB_USER, DB_PASSWD, DB_NAME);
    }

    function getProfiles() {
        $results = $this->con->query("SELECT `profile_id`, `name`, `description`, `owner`, DATE_FORMAT(`created`, '%d-%m-%Y') AS created FROM `profiles` WHERE 1");
        return $this->_resultsToArray($results);
    }

    function getProfile($profile_id) {
        $results = $this->con->query("SELECT *, DATE_FORMAT(`created`, '%d-%m-%Y') AS created FROM `profiles` WHERE profile_id = $profile_id");
        $results = $this->_resultsToArray($results);
        if (count($results)) {
            return $results;
        } else {
            return false;
        }
    }
    
    function getProfileByMetaDataID($md_id) {
        $results = $this->con->query("SELECT p.profile_id, p.name, p.language FROM `profiles` AS p, metadata_records AS m WHERE m.id = $md_id AND p.profile_id = m.profile_id");
        $results = $this->_resultsToArray($results);
        if (count($results)) {
            return $results;
        } else {
            return false;
        }
    }
    
    function checkRecordById($id)
    {
        $results = $this->con->query("SELECT `id` FROM metadata_records WHERE id = $id");
        $results = $this->_resultsToArray($results);

        if (count($results) == 1) {
            return true;
        } else {
            return false;
        }
    }

    function removeRecord($id) {

        if ($this->checkRecordById($id)) {
            $results = $this->con->query("DELETE FROM metadata_records WHERE id = ${id} LIMIT 1;");
            return $results;
        } else {
            return false;
        }
    }
    
    function addRecord($title, $profile) {
        $this->con->query("INSERT INTO metadata_records (name, profile_id, creator, creation_date) VALUES ('$title', $profile, 'Rob Zeeman', NOW())");
        $result = $this->con->query("SELECT LAST_INSERT_ID() AS last");
        $row = $result->fetch_assoc();
        return $row["last"];
    }
    
    function getMetadataRecords($profile_id)
    {
        $results = $this->con->query("SELECT `id`, `name`, `record_status`,`creator`, `creation_date` FROM `metadata_records` WHERE `profile_id` = $profile_id");
        return $this->_resultsToArray($results);
    }

    private function _resultsToArray($results) {
        $resultArray = array();
        while ($row = $results->fetch_assoc()) {
            $resultArray[] = $row;
        }

        return $resultArray;
    }

}
