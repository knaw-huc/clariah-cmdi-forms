{*{extends file="standardPage.tpl"}*}
{*{block name="content"}*}
{*    <h2>Create new CMDI record ({$profileName})</h2>*}
{*    <form method="post" action="{$home_path}index.php?page=add_record">*}
{*        <div id="newRecTab">*}
{*            <div class="newRecRow">*}
{*                <div class="newRecLab">Title:</div>*}
{*                <div class="newRecField"><input type="text" size="80" name="title"></div>*}
{*            </div>*}
{*            <div class="newRecRow">*}
{*                <div class="newRecLab">Creator:</div>*}
{*                <div class="newRecField">Rob Zeeman</div>*}
{*            </div>*}
{*            <div class="newRecRow">*}
{*                <div class="newRecLab">Date:</div>*}
{*                <div class="newRecField">{$date}</div>*}
{*            </div>*}
{*        </div>*}
{*        <input type="hidden" name="profile_id" value="{$profile_id}">*}
{*        <input type="button" value="OK" id="submit">*}
{*    </form>*}
{*    {literal}*}
{*        <script type="text/javascript">*}
{*            alert("test");*}
{*            let submit = document.getElementById("submit");*}
{*            submit.onclick = function() {*}
{*                setTimeout(*}
{*                    function() {*}
{*                        console.log("form submitted");*}
{*                    }*}
{*                )*}
{*            };*}

{*        </script>*}
{*    {/literal}*}
{*{/block}*}