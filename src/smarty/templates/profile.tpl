{extends file="standardPage.tpl"}
{block name="content"}
    <h2>CMDI profile</h2>
    <div class="itemGrid">
        <div class="itemGridRow">
            <div class="itemGridCell labelCell">Profile name</div>
            <div class="itemGridCell">{$profile.name}</div>
        </div>
        <div class="itemGridRow">
            <div class="itemGridCell labelCell">Description</div>
            <div class="itemGridCell">{$profile.description}</div>
        </div>
        <div class="itemGridRow">
            <div class="itemGridCell labelCell">Owner</div>
            <div class="itemGridCell">{$profile.owner}</div>
        </div>
        <div class="itemGridRow">
            <div class="itemGridCell labelCell">Created</div>
            <div class="itemGridCell">{$profile.created}</div>
        </div>
    </div>

    <div id="profileData">
        <ul id="profileDataNavigator">
            {if $profileTab == 1}
                <li id="profileXMLTab"{if $state == 'profile'} class="profileDataActiveTab"{/if}>Profile</li>
            {/if}
            {if $tweakTab == 1}
                <li id="profileTweakTab">Tweak</li>
            {/if}
            {if $recordsTab == 1}
                <li id="profileRecordsTab"{if $state == 'records'} class="profileDataActiveTab"{/if}>Records</li>
            {/if}
        </ul>
        <div id="profileDetails">
            <div id="profileXML" {if $state == 'records'} class="noView"{/if}><textarea class="viewText" readonly="yes">{$profile.content}</textarea></div>
            <!--<div id="profileJSON" class="noView"><textarea class="viewText" readonly="yes">{$profile.json|nl2br}</textarea></div>-->
            <div id="tweakXML" class="noView"><textarea class="viewText" readonly>{$profile.tweak}</textarea></div>
            <div id="metadataRecs" {if $state != 'records'}class="noView"{/if}>
                <table id="resultTable">
                    <tr><th>Title</th><th>Status</th><th>Creator</th><th>Creation date</th><th><a href="{$home_path}index.php?page=new_rec&profile={$profile.profile_id}" id="addRec"><img src="{$home_path}img/add.ico" height="16px" width="16px"></a></th><th></th><th></th></th></tr>
                            {foreach from=$records item=record}
                        <tr class="{cycle values="odd,even"}">
                            <td>{$record.name}</td>
                            <td>{$record.record_status}</td>
                            <td>{$record.creator}</td>
                            <td>{$record.creation_date}</td>
                            <td><a href="{$home_path}index.php?page=metadata&id={$record.id}" title="Edit metadata"><img src="{$home_path}img/edit.png" height="16px" width="16px"></a></td>
                            <td><a href="{$home_path}index.php?page=profile&id={$record.id}&action=download_record" title="Download"><img src="{$home_path}img/download.png" height="16px" width="16px"></a></td>
                            <td><a href="#" title="Delete" class="myBtn" id="myBtn{$record.id}" onclick="deleteRecord({$record.id}, {$profile.profile_id});"><img src="{$home_path}img/bin.png" height="16px" width="16px"></a></td>
                        </tr>
                    {/foreach}
                </table>
            </div>
            </div>
        </div>
    </div>

    <div id="dialog-confirm" title="Record Deletion Confirmation" style="display: none;">
        <p><span class="ui-icon ui-icon-alert" style="float:left; margin:12px 12px 20px 0;"></span>This record will be permanently deleted and cannot be recovered. Are you sure?</p>
    </div>


{literal}
    <!-- JQuery -->
    <script type="text/javascript">
        function deleteRecord(recordId, profileId) {
            let myBtn = document.getElementById(recordId);

            $( "#dialog-confirm" ).dialog({
                resizable: false,
                height: "auto",
                width: 400,
                modal: true,
                buttons: {
                    "DELETE": function() {
                        console.log("Deleting record: [" + recordId + "]\n");
                        $.ajax({
                            url: 'index.php?page=profile&id=' + recordId + '&action=delete_record&profile_id=' + profileId,
                            success: function() {
                                console.log("done");
                                location.reload();
                            },
                            error: function() {
                                console.log("failed");
                            }
                        });
                        $( this ).dialog( "close" );

                    },
                    Cancel: function() {
                        $( this ).dialog( "close" );
                    }
                }
            });
        }

    </script>

{/literal}

{/block}