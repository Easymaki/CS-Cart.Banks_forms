<select id="elm_{$elm_id}" name="bank_data[form][{$num}][element_type]" onchange="fn_check_element_type(this.value, this.id, '{$selectable_elements}');">
    <optgroup label="{__("type")}">
    <option value="{$smarty.const.FORM_SELECT}" {if $element_type == $smarty.const.FORM_SELECT}selected="selected"{/if}>{__("selectbox")}</option>
    <option value="{$smarty.const.FORM_INPUT}" {if $element_type == $smarty.const.FORM_INPUT}selected="selected"{/if}>{__("input_field")}</option>
    </optgroup>
</select>