<div class="control-group">
    <h1>{__("payment_information")}: {__("order")} #{$order_id}</h1>
<div>
<div class="ty-profile-field ty-account form-wrap">
    <form name="payment_data" enctype="multipart/form-data" method="post">
    <input type="hidden" class="cm-no-hide-input" name="order_id" value="{$order_id}" />

    <div class="ty-control-group">
        <label for="fullname" class="ty-control-group__title cm-required">{__("b_fullname")}</label>
        <input type="text" id="fullname" name="payment_data[full_name]" class="input-text-large cm-focus" size="25" maxlength="255" value="{$search.payment_data.fullname}" />
    </div>

    <div class="ty-control-group" id="content_general">
    {if $banks}
        <label for="select_bank" class="ty-control-group__title cm-required">{__("bank")}</label>
        <select id="select_bank">
            <option value="">- {__("select_bank")} -</option>
            {foreach from=$banks item=bank}
                <option {if $search.bank_id == $bank.bank_id} selected="selected" {/if} value="{$bank.bank_id}">{$bank.bank}</option>
            {/foreach}
        </select>
    {/if}
    </div>

    {if $forms}
        <div class="ty-control-group">
            {foreach from=$forms item="element" name="form_id"}
                {if $element.element_type == 'I'}
                <div class="ty-control-group">
                    <label for="input_form" value="{$element.description}"</label>
                    <input id="input_form" class="input-text" type="text" size="15" name="payment_data[forms][{$element.form_id}]" value="{$element.description}" /></td>
                </div>
                {elseif $element.element_type == 'S'}
                    <label>{$element.description}</label>
                    {if !empty($element.variants)}
                        <select name="payment_data[forms][{$element.form_id}]" id="select_form">
                            {foreach from=$element.variants item=var}
                                <div class="ty-control-group">
                                    <option size="15" value="{$var.element_id}">{$var.description}</option>
                                </div>
                            {/foreach}
                        </select>
                    {/if}
                {/if}
            {/foreach}
        </div>
    {/if}
<!--content_general--></div>

<div class="ty-float-left">
    {include file="buttons/save.tpl"  but_role="submit-link" but_target_form="payment_data" but_name="dispatch[orders.banks]"}
</div>
</form>


{capture name="mainbox_title"}
    {__("order")}&nbsp;
{/capture}
