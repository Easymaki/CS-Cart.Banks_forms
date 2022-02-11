<td>
{if $o.status == 'O'}
    <a href="{"banks.fill?order_id=`$o.order_id`"|fn_url}">{__("banks_fill")}</a>
{else}
    {__("text_no_payments_needed")}
{/if}
</td>
