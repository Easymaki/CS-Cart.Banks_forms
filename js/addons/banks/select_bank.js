/**
 *
 * Select bank in Front
 *
 */
(function(_, $) {
 $.ceEvent('on', 'ce.commoninit', function(context) {  
        if ($('#select_bank', context).length > 0) {
            $("#select_bank").off('change').on('change', function(){
                var bank_id = $(this).val();
                $.ceAjax('request', fn_url("banks.fill"), {
                    data:{
                        bank_id: bank_id,
                        loc: 'banks',
                        result_ids: 'content_general',
                        method: 'get',
                        fullrender: true
                    }
                });
            });
        }
    });
}(Tygh, Tygh.$));
        