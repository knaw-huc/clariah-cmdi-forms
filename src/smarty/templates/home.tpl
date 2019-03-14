{extends file="standardPage.tpl"}
{block name="content"}
    <h2>CMDI profiles</h2>
    <table id="resultTable">
        <tr><th>Name</th><th>Description</th><th>Owner</th><th>Created</th><th></th><th></th><th></th></tr>
        {foreach from=$profiles item=profile}
            <tr class="{cycle values="odd,even"}">
                <td>{$profile.name}</td>
                <td>{$profile.description}</td>
                <td>{$profile.owner}</td>
                <td>{$profile.created}</td>
                <td><a href="{$home_path}index.php?page=profile&id={$profile.profile_id}" title="View profile"><img src="{$home_path}img/view.png" height="16px" width="16px"></a></td>
                <td><a href="{$home_path}index.php?page=profile&id={$profile.profile_id}&state=records" title="View metadata records"><img src="{$home_path}img/more-items.png" height="16px" width="16px"></a></td>
                <td><a href="" title="Delete profile"><img src="{$home_path}img/bin.png" height="16px" width="16px"></a></td>
            </tr>
        {/foreach}
    </table> 
 {/block}