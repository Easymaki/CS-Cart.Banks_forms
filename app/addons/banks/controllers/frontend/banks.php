<?php

use Tygh\Registry;

if (!defined('BOOTSTRAP')) {
    die('Access denied');
}

$params = $_REQUEST;

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    if ($mode == 'fill') {
        $payment_data = fn_banks_add_payment_data_to_db($_REQUEST['payment_data'], $_REQUEST['order_id']);

        $suffix = 'search';
    }
    return array(CONTROLLER_STATUS_OK, 'orders.' . $suffix);
}

if ($mode == 'fill') {
    $banks = fn_banks_get_banks(DESCR_SL);
    $order_id = $_REQUEST['order_id'];

    if (defined('AJAX_REQUEST')) {
        $forms = fn_banks_get_form_elements($_REQUEST['bank_id'], DESCR_SL);

        Tygh::$app['view']->assign('forms', $forms);
    }

    Tygh::$app['view']->assign('order_id', $order_id);
    Tygh::$app['view']->assign('search', $params);
    Tygh::$app['view']->assign('banks', $banks);
}
