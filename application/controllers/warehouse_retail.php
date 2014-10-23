<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Warehouse_retail extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('products_model', 'product');
        $this->load->model('products_sale_price_model', 'product_sale');
        $this->load->model('products_buy_price_model', 'product_buy');
        $this->load->model('warehouse_retail_model', 'retail');
    }

    public function index() {
        $products = $this->retail->get_all();
        echo json_encode(array('products' => $products));
    }

    public function addRetail() {
        $products = $this->product->get_all();
        echo json_encode(array('products' => $products));
    }

    public function saveAddRetail() {
        $retail = $this->input->json();
        //insert product_buy_price
        $buy_list = array();
        $reatail_list = array();
        foreach ($retail->buy_price as $item => $value) {
            $unit_primary = $this->product_sale->get_unit_retail($value->product_id);
            $buy_list = array('product_id' => $value->product_id,
                'price' => $value->price,
                'warehouse' => 'retail',
                'unit' => $unit_primary->id,
                'quantity' => $value->quantity,
                'remaining_quantity' => $value->quantity,
                'partner' => $retail->partner);
            $this->product_buy->insert($buy_list);
            //insert or update quantity

            $retail_product = $this->retail->get_by_product_id($value->product_id);

            if (count($retail_product) > 0) {
                $retail_list = array('quantity' => ((int) $value->quantity + (int) $retail_product->quantity));
                $this->retail->update($retail_list, array('product_id' => $value->product_id));
            } else {
                $retail_list = array('quantity' => $value->quantity,
                    'unit' => $unit_primary->id,
                    'product_id' => $value->product_id);
                $this->retail->insert($retail_list);
            }
        }
        echo json_encode($retail);
    }

}
