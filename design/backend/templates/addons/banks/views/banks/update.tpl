{if $bank}
    {assign var="id" value=$bank.bank_id}
{else}
    {assign var="id" value=0}
{/if}

{capture name="mainbox"}

<form action="{""|fn_url}" method="post" class="form-horizontal form-edit" name="bank_form" enctype="multipart/form-data">
<input type="hidden" class="cm-no-hide-input" name="fake" value="1" />
<input type="hidden" class="cm-no-hide-input" name="bank_id" value="{$id}" />

<div id="content_general">
    <div class="control-group">
        <label for="elm_bank_name" class="control-label cm-required">{__("name")}</label>
        <div class="controls">
            <input type="text" name="bank_data[bank]" id="elm_bank_name" value="{$bank.bank}" size="25" class="input-large" />
        </div>
    </div>
    <div class="control-group">
        <label for="elm_bank_position" class="control-label">{__("position")}</label>
        <div class="controls">
            <input type="text" name="bank_data[position]" id="elm_bank_position" value="{$bank.position}" size="3" class="input-large" />
        </div>
    </div>
</div>

{include file="common/select_status.tpl" input_name="bank_data[status]" id="elm_banner_status" obj_id=$id obj=$bank hidden=false}
 
{if !id}
    {capture name="tools_list"}
            <li>{btn type="list" text=__("delete") class="cm-confirm" href="products.delete_bank?bank_id=`$id`" method="POST"}</li>
    {/capture}
    {dropdown content=$smarty.capture.tools_list}
{/if}

{capture name="buttons"}
    {if !$id}
        {include file="buttons/save_cancel.tpl" but_role="submit-link" but_target_form="bank_form" but_name="dispatch[banks.update]"}
    {else}
        {include file="buttons/save_cancel.tpl" but_name="dispatch[banks.update]" but_role="submit-link" but_target_form="bank_form" hide_first_button=$hide_first_button hide_second_button=$hide_second_button save=$id}
    {/if}
{/capture}

<h3>{__("extra_fields")}</h3>
{include file="addons/banks/views/banks/components/extra_fields.tpl"}

</form>

{/capture}

{if !$id}
    {$title = {__("add_bank")}}
{else}
    {$title_start = {__("edit")}}
    {$title_end = $bank.bank}
{/if}

{include file="common/mainbox.tpl"
    content=$smarty.capture.mainbox
    buttons=$smarty.capture.buttons
    select_languages=true}
