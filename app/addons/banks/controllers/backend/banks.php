<?php

use Tygh\Registry;

defined('BOOTSTRAP') or die('Access denied');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {

    if ($mode == 'update') {
        $bank_id = fn_banks_update_bank($_REQUEST['bank_data'], $_REQUEST['bank_id'], DESCR_SL);
        $suffix = ".update?bank_id=$bank_id";
    } elseif ($mode == 'delete') {
        if (!empty($_REQUEST['bank_id'])) {
            fn_delete_bank_by_id($_REQUEST['bank_id']);
            $suffix = '.manage';
        }
    }
    return array(CONTROLLER_STATUS_OK, 'banks' . $suffix);
}

if ($mode == 'manage') {
    $banks = fn_banks_get_banks(DESCR_SL);

    Tygh::$app['view']->assign('banks', $banks);
} elseif ($mode == 'update') {
    $bank_id = !empty($_REQUEST['bank_id']) ? $_REQUEST['bank_id'] : 0;

    $bank = fn_banks_get_bank_data($bank_id, DESCR_SL);

    if ((empty($bank)) && ($mode == 'update')) {
        return [CONTROLLER_STATUS_NO_PAGE];
    }

    Tygh::$app['view']->assign('form', $bank['form']);
    Tygh::$app['view']->assign('bank', $bank);
}
