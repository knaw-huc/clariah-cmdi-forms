{extends file="standardPage.tpl"}
{block name="content"}
    <h2>Errors</h2>
    {foreach from=$errors item=error}
        <p>{$error}</p>
    {/foreach}
 {/block}