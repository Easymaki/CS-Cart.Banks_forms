{literal}
<script>
    function fn_check_element_type(elm, id, selectable_elements)
    {
        var $ = Tygh.$;
        var elem_id = id.replace('elm_', 'box_element_variants_');
        $('#' + elem_id).toggleBy(selectable_elements.indexOf(elm) == -1);

        // Hide description box for separator
        $('#descr_' + id).toggleBy((elm == 'D'));
        $('#hr_' + id).toggleBy((elm != 'D'));

        $('#req_' + id).prop('disabled', (elm == 'D' || elm == 'H'));
    }

    function fn_go_check_element_type(id, selectable_elements)
    {
        var $ = Tygh.$;
        var id = id || '';

        var c = parseInt(id.replace('add_elements', '').replace('_', ''));
        c = (isNaN(c))? 1 : c++;
        var c_id = c.toString();
        $('#elm_add_variants_' + c_id).trigger('change');
    }
</script>
{/literal}

{assign var="allow_save" value=true}
{if "ULTIMATE"|fn_allowed_for}
    {assign var="allow_save" value=$bank_data|fn_allow_save_object:"banks"}
{/if}

<div class="table-responsive-wrapper">
    <table class="table hidden-inputs table-middle table--relative table-responsive">
    <thead>
        <tr>
            <th width="3%">&nbsp;</th>
            <th width="4%">{__("position_short")}</th>
            <th width="25%">{__("name")}</th>
            <th width="25%">{__("type")}</th>
            <th width="25%">&nbsp;</th>
            <th width="6%" class="right">{__("status")}</th>
        </tr>
    </thead>
    {foreach from=$form item="element" name="fe_e"}
    {assign var="num" value=$smarty.foreach.fe_e.iteration}
    <tbody class="cm-row-item cm-row-status-{$element.status|lower}">
    <tr>
        <td data-th="&nbsp;">
            <div id="on_box_element_variants_{$element.form_id}" class="hand btn cm-combination-options-{$element.form_id}"><span class="icon-caret-right"></span></div>
            <div id="off_box_element_variants_{$element.form_id}" class="hand btn hidden cm-combination-options-{$element.form_id}"><span class="icon-caret-down"></span> </div>
        </td>
        <td class="nowrap" data-th="{__("position_short")}">
            <input type="hidden" name="bank_data[form][{$num}][form_id]" value="{$element.form_id}" />
            <input class="input-micro" type="text" size="3" name="bank_data[form][{$num}][position]" value="{$element.position}" /></td>
        <td data-th="{__("name")}">
            <input id="descr_elm_{$element.form_id}" class="{if $element.element_type == $smarty.const.FORM_SEPARATOR}hidden{/if}" type="text" name="bank_data[form][{$num}][description]" value="{$element.description}" />
            <hr id="hr_elm_{$element.form_id}" width="100%" {if $element.element_type != $smarty.const.FORM_SEPARATOR}class="hidden"{/if} /></td>
        <td data-th="{__("type")}">
            {include file="addons/banks/views/banks/components/element_types.tpl" element_type=$element.element_type elm_id=$element.form_id}</td>
        <td data-th="&nbsp;">
            {include file="buttons/multiple_buttons.tpl" only_delete="Y"}
        </td>
        <td class="right" data-th="{__("status")}">
            {include file="common/select_popup.tpl" id=$element.form_id prefix="elm" status=$element.status hidden="" object_id_name="element_id" table="bank_form"}
        </td>
    </tr>
    <tr id="box_element_variants_{$element.form_id}" class="{if !$selectable_elements|substr_count:$element.element_type}hidden{/if} row-more row-gray hidden">
        <td>&nbsp;</td>
        <td colspan="5">
            <div class="table-responsive-wrapper">
                <table class="table table-middle table--relative table-responsive">
                <thead>
                    <tr class="cm-first-sibling">
                        <th width="5%" class="left">{__("position_short")}</th>
                        <th>{__("variant")}</th>
                        <th>&nbsp;</th>
                    </tr>
                </thead>
                {foreach from=$element.variants item=var key="vnum"}
                <tr class="cm-first-sibling cm-row-item">
                    <td data-th="{__("position_short")}">
                        <input type="hidden" name="bank_data[form][{$num}][variants][{$vnum}][element_id]" value="{$var.element_id}" />
                        <input class="input-micro" size="3" type="text" name="bank_data[form][{$num}][variants][{$vnum}][position]" value="{$var.position}" /></td>
                    <td data-th="{__("variant")}">
                        <input type="text" class="span7" name="bank_data[form][{$num}][variants][{$vnum}][description]" value="{$var.description}" /></td>
                    <td data-th="&nbsp;">
                        {include file="buttons/multiple_buttons.tpl" only_delete="Y"}
                    </td>
                </tr>
                {/foreach}
                {math equation="y + 1" assign="vnum" y=$vnum|default:0}
                <tr id="box_elm_variants_{$element.form_id}" class="cm-row-item cm-elm-variants">
                    <td data-th="{__("position_short")}">
                        <input class="input-micro" size="3" type="text" name="bank_data[form][{$num}][variants][{$vnum}][position]" />
                    </td>
                    <td data-th="{__("variant")}">
                        <input type="text" class="span7" name="bank_data[form][{$num}][variants][{$vnum}][description]" />
                    </td>
                    <td data-th="&nbsp;">
                        {include file="buttons/multiple_buttons.tpl" item_id="elm_variants_`$element.form_id`" tag_level="3"}
                    </td>
                </tr>
                </table>
            </div>
        </td>
        <td>&nbsp;</td>
    </tr>
    </tbody>
    {/foreach}

    {math equation="x + 1" assign="num" x=$num|default:0}
    <tbody class="cm-row-item cm-row-status-a" id="box_add_elements">
    <tr class="no-border">
        <td data-th="&nbsp;">&nbsp;</td>
        <td class="right" data-th="{__("position_short")}">
            <input class="input-micro" size="3" type="text" name="bank_data[form][{$num}][position]" value="" />
        </td>
        <td data-th="{__("name")}">
            <input id="descr_elm_add_variants" type="text" name="bank_data[form][{$num}][description]" value="" />
            <hr id="hr_elm_add_variants" class="hidden" />
        </td>
        <td data-th="{__("type")}">
            {include file="addons/banks/views/banks/components/element_types.tpl" element_type="" elm_id="add_variants"}
        </td>
        <td class="left" data-th="&nbsp;">
            {include file="buttons/multiple_buttons.tpl" item_id="add_elements" on_add="fn_go_check_element_type();"}
        </td>
        <td class="right" data-th="{__("status")}">
            {include file="common/select_status.tpl" input_name="bank_data[form][`$num`][status]" display="popup"}
        </td>
    </tr>
    <tr id="box_element_variants_add_variants" class="row-more row-gray">
        <td>&nbsp;</td>
        <td colspan="5">
            <div class="table-responsive-wrapper">
                <table class="table table-middle table--relative table-responsive">
                <thead>
                    <tr class="cm-first-sibling">
                        <th width="5%" class="left">{__("position_short")}</th>
                        <th>{__("description")}</th>
                        <th>&nbsp;</th>
                    </tr>
                </thead>
                <tr id="box_elm_variants_add_variants" class="cm-row-item cm-elm-variants">
                    <td data-th="{__("position_short")}">
                        <input class="input-micro" size="3" type="text" name="bank_data[form][{$num}][variants][0][position]" />
                    </td>
                    <td data-th="{__("description")}">
                        <input class="span7" type="text" name="bank_data[form][{$num}][variants][0][description]" />
                    </td>
                    <td data-th="&nbsp;">
                        {include file="buttons/multiple_buttons.tpl" item_id="elm_variants_add_variants" tag_level="3"}
                    </td>
                </tr>
                </table>
            </div>
        </td>
        <td>&nbsp;</td>
    </tr>
    </tbody>
    </table>
</div>
