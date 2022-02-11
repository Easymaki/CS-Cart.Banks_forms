{capture name="mainbox"}

<form method="post" id="banks_form" name="banks_form" enctype="multipart/form-data">
<input type="hidden" name="fake" value="1" />

{if $banks}
    {capture name="banks_table"}
        <div class="table-responsive-wrapper longtap-selection">
            <table class="table table-middle table--relative table-responsive">
            <thead>
            <tr>
                <th>{__("position")}</th>
                <th>{__("name")}</th>
                <th width="6%" class="mobile-hide"></th>
                <th width="10%" class="right">{__("status")}</th>
            </tr>
            </thead>
            {foreach from=$banks item=bank}
            <tr class="cm-row-status-{$bank.status|lower} cm-longtap-target">
                <td width="6%" class="left mobile-hide">{$bank.position}</td>
                <td class="{$no_hide_input}" data-th="{__("name")}">
                    <a class="row-status" href="{"banks.update?bank_id=`$bank.bank_id`"|fn_url}">{$bank.bank}</a>
                </td>
                <td width="6%" class="mobile-hide">
                    {capture name="tools_list"}
                        <li>{btn type="list" text=__("edit") href="banks.update?bank_id=`$bank.bank_id`"}</li>
                        <li>{btn type="list" class="cm-confirm" text=__("delete") href="banks.delete?bank_id=`$bank.bank_id`" method="POST"}</li>
                    {/capture}
                    <div class="hidden-tools">
                        {dropdown content=$smarty.capture.tools_list}
                    </div>
                </td>
                <td width="10%" class="right" data-th="{__("status")}">
                    {include file="common/select_popup.tpl" id=$bank.bank_id status=$bank.status hidden=true object_id_name="bank_id" table="banks"}
                </td>
            </tr>
            {/foreach}
            </table>
        </div>
    {/capture}

    {include file="common/context_menu_wrapper.tpl"
        form="banks_form"
        object="banks"
        items=$smarty.capture.banks_table
    }
{else}
    <p class="no-items">{__("no_data")}</p>
{/if}

{capture name="adv_buttons"}
    {include file="common/tools.tpl" tool_href="banks.add" prefix="top" title=__("add_bank") icon="icon-plus"}
{/capture}
</form>

{/capture}

{hook name="banks:manage_mainbox_params"}
    {$page_title = __("banks")}
    {$select_languages = true}
{/hook}

{include file="common/mainbox.tpl"
    title=$smarty.capture.mainbox_title
    content=$smarty.capture.mainbox
    title_extra=$smarty.capture.title_extra
    adv_buttons=$smarty.capture.adv_buttons
    select_languages=true
    buttons=$smarty.capture.buttons
    sidebar=$smarty.capture.sidebar
    content_id="manage_banks"
}