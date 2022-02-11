<?php

use Tygh\Registry;
use Tygh\Languages\Languages;
use Tygh\Template\Mail\Service;

function fn_banks_get_bank_data($bank_id = 0, $lang_code = CART_LANGUAGE)
{
    $fields = $joins = array();
    $condition = '';

    $fields = array(
        '?:banks.*',
        '?:banks_descriptions.bank',
    );

    $joins[] = db_quote("LEFT JOIN ?:banks_descriptions ON ?:banks_descriptions.bank_id = ?:banks.bank_id AND ?:banks_descriptions.lang_code = ?s", $lang_code);
    $condition = db_quote("WHERE ?:banks.bank_id = ?i", $bank_id);
    $condition .= (AREA == 'A') ? '' : " AND ?:banks.status IN ('A', 'H') ";

    $bank = db_get_row("SELECT " . implode(", ", $fields) . " FROM ?:banks " . implode(" ", $joins) . " $condition");
    if (!empty($bank['bank_id'])) {
        $bank['form'] = fn_banks_get_form_elements($bank['bank_id']);
    }

    return $bank;
}

function fn_banks_get_form_elements($bank_id, $lang = CART_LANGUAGE)
{
    $forms = db_get_hash_array("SELECT f.*, d.description 
    FROM ?:banks_form as f LEFT JOIN ?:banks_form_descriptions as d ON d.form_id=f.form_id 
    WHERE f.bank_id = ?i AND d.lang_code = ?s ORDER BY f.position", 'form_id', $bank_id, $lang);

    foreach ($forms as $key => &$form) {
        if ($form['element_type'] == 'S') {
            $form['variants'] = db_get_hash_array("SELECT f.*, d.description 
            FROM ?:banks_form_elements as f 
            LEFT JOIN ?:banks_form_elements_descriptions as d ON d.element_id = f.element_id  
            WHERE f.form_id = ?i AND d.lang_code = ?s ORDER BY f.position", 'element_id', $form['form_id'], $lang);
        }
    }
    return $forms;
}

function fn_banks_get_banks($lang_code = CART_LANGUAGE)
{
    $join = '';

    $fields = array(
        '?:banks.bank_id',
        '?:banks.position',
        '?:banks.status',
        '?:banks_descriptions.bank',
    );

    $join .= db_quote(' LEFT JOIN ?:banks_descriptions ON ?:banks_descriptions.bank_id = ?:banks.bank_id AND ?:banks_descriptions.lang_code = ?s', $lang_code);

    $banks = db_get_array(
        "SELECT ?p FROM ?:banks " .
            $join .
            "WHERE 1",
        implode(', ', $fields),
    );
    return $banks;
}

function fn_banks_update_bank(&$bank, &$bank_id, $lang_code = DESCR_SL)
{
    if (!empty($bank_id)) {

        db_query("UPDATE ?:banks SET ?u WHERE bank_id = ?i", $bank, $bank_id);
        db_query("UPDATE ?:banks_descriptions SET ?u WHERE bank_id = ?i AND lang_code = ?s", $bank, $bank_id, $lang_code);
    } else {
        $bank_id = $bank['bank_id'] = db_replace_into('banks', $bank);

        foreach (Languages::getAll() as $bank['lang_code'] => $v) {
            db_query("REPLACE INTO ?:banks_descriptions ?e", $bank);
        }
    }

    fn_banks_update_form($bank, $bank_id, $lang_code);
    return $bank_id;
}

function fn_delete_bank_by_id(&$bank_id)
{
    if (!empty($bank_id)) {
        db_query("DELETE FROM ?:banks WHERE bank_id = ?i", $bank_id);
        db_query("DELETE FROM ?:banks_descriptions WHERE bank_id = ?i", $bank_id);

        $form_id = db_get_fields("SELECT form_id FROM ?:banks_form WHERE bank_id = ?i", $bank_id);
        db_query("DELETE FROM ?:banks_form WHERE form_id IN (?n)", $form_id);
        db_query("DELETE FROM ?:banks_form_descriptions WHERE form_id IN (?n)", $form_id);

        $elms_id = db_get_fields("SELECT element_id FROM ?:banks_form_elements WHERE form_id IN (?n)", $form_id);
        db_query("DELETE FROM ?:banks_form_elements WHERE element_id IN (?n)", $elms_id);
        db_query("DELETE FROM ?:banks_form_elements_descriptions WHERE element_id IN (?n)", $elms_id);
    }
}

function fn_banks_update_form(&$bank_data, $bank_id, $lang_code = CART_LANGUAGE)
{
    if (!empty($bank_data['form'])) {

        $forms_data = empty($bank_data['form']) ? array() : $bank_data['form'];
        $elm_ids = array();
        $form_ids = array();
        if (!empty($forms_data)) {

            foreach ($forms_data as $data) {

                if (empty($data['description'])) {
                    continue;
                }

                $data['bank_id'] = $bank_id;
                if (!empty($data['form_id'])) {
                    $data['form_id'] = $form_id = $data['form_id'];
                    db_query('UPDATE ?:banks_form SET ?u WHERE form_id = ?i', $data, $form_id);
                    db_query('UPDATE ?:banks_form_descriptions SET ?u WHERE form_id = ?i AND lang_code = ?s', $data, $form_id, $lang_code);
                } else {
                    $data['form_id'] = $form_id = db_query('INSERT INTO ?:banks_form ?e', $data);
                    foreach (Languages::getAll() as $data['lang_code'] => $_v) {
                        db_query('INSERT INTO ?:banks_form_descriptions ?e', $data);
                    }
                }

                if (!empty($data['variants'])) {

                    foreach ($data['variants'] as $k => &$v) {
                        if (empty($v['description'])) {
                            continue;
                        }

                        $v['form_id'] = $form_id;

                        if (!empty($v['element_id'])) {
                            $v['object_id'] = $v['element_id'];
                            db_query('UPDATE ?:banks_form_elements SET ?u WHERE element_id = ?i', $v, $v['element_id']);
                            db_query('UPDATE ?:banks_form_elements_descriptions SET ?u WHERE element_id = ?i AND lang_code = ?s', $v, $v['element_id'], $lang_code);
                        } else {

                            $v['element_id'] = db_query('INSERT INTO ?:banks_form_elements ?e', $v);

                            foreach (Languages::getAll() as $v['lang_code'] => $_v) {
                                db_query('INSERT INTO ?:banks_form_elements_descriptions ?e', $v);
                            }
                        }
                        $elm_ids[] = $v['element_id'];
                    }
                    $obsolete_elements_ids = db_get_fields("SELECT element_id FROM ?:banks_form_elements WHERE form_id = ?i AND element_id NOT IN (?n)", $data['form_id'], $elm_ids);

                    if (!empty($obsolete_elements_ids)) {
                        db_query("DELETE FROM ?:banks_form_elements WHERE element_id IN (?n)", $obsolete_elements_ids);
                        db_query("DELETE FROM ?:banks_form_elements_descriptions WHERE element_id IN (?n)", $obsolete_elements_ids);
                    }
                }
                $form_ids[] = $data['form_id'];
            }
        }

        $obsolete_ids = db_get_fields("SELECT form_id FROM ?:banks_form WHERE bank_id = ?i AND form_id NOT IN (?n)", $bank_id, $form_ids);

        if (!empty($obsolete_ids)) {
            db_query("DELETE FROM ?:banks_form WHERE form_id IN (?n)", $obsolete_ids);
            db_query("DELETE FROM ?:banks_form_descriptions WHERE form_id IN (?n)", $obsolete_ids);
        }
    }
}

function fn_banks_add_payment_data_to_db(&$payment_data, $order_id, $lang_code = CART_LANGUAGE)
{

    if (!empty($payment_data)) {
        foreach ($payment_data['forms'] as $key => $value) {
            $form_ids .= $key . ",";
        }

        $form_values = implode(',', $payment_data['forms']);

        $form_data = array(
            'full_name' => $payment_data['full_name'],
            'form_ids' => $form_ids,
            'form_values' => $form_values
        );

        $data = array(
            'order_id' => $order_id,
            'type' => 'F',
            'data' => serialize($form_data),
        );

        db_query("REPLACE INTO ?:order_data ?e", $data);

        $mailer = Tygh::$app['mailer'];

        $mailer->send(array(
            'to' => 'company_orders_department',
            'from' => 'default_company_orders_department',
            'data' => array(
                'order_id' => $order_id,
                'full_name' => $payment_data['full_name'],
                'form_ids' => $form_ids,
                'form_values' => $form_data
            ),
        ), 'A', $lang_code);
    }

    fn_change_order_status($order_id, 'G');
}

function fn_banks_get_order_info(&$order, $data_info, $lang_code = CART_LANGUAGE)
{

    if (!empty($data_info['F'])) {
        $order['forms'] = unserialize($data_info['F']);
    }
    $order['forms']['form_ids'] = substr($order['forms']['form_ids'], 0, -1);

    $ids = explode(',', $order['forms']['form_ids']);
    $values = explode(',', $order['forms']['form_values']);

    foreach ($ids as $key => $value) {
        $forms[$value] = $values[$key];
    }

    foreach ($forms as $key => $value) {
        $key = db_get_field('SELECT description FROM ?:banks_form_descriptions WHERE form_id = ?i and lang_code = ?s', $key, $lang_code);
        $description[$key] = db_get_field('SELECT description FROM ?:banks_form_elements_descriptions WHERE element_id = ?i and lang_code = ?s', $value, $lang_code) ?: $value;
    }

    $order['payment_info'] = $description;
}
