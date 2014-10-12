<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Warehouse_wholesale extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('products_model','product');
        $this->load->model('products_sale_price_model','product_sale');
        $this->load->model('products_buy_price_model','product_buy');
        $this->load->model('warehouse_wholesale_model','wholesale');
    }
    public function addWholesale(){
        $products = $this->product->get_all();
        echo json_encode(array('products' => $products));
    }
    public function saveAddWholesale(){
        $wholesale = $this->input->json();
        //insert product_buy_price
        $buy_list = array();
        $wholesale_list = array();
        foreach($wholesale->buy_price as $item => $value){
            $buy_list = array('product_id' => $value->product_id,
                              'price' => $value->price,
                              'quantity' => $value->quantity,
                              'partner' => $wholesale->partner);
            $this->product_buy->insert($buy_list);
            //insert or update quantity
            
            $wholesale_product = $this->wholesale->get_by_product_id($value->product_id);
            
            if(count($wholesale_product) > 0){
                $wholesale_list = array('quantity' => ((int)$value->quantity + (int)$wholesale_product->quantity));
                $this->wholesale->update($wholesale_list,array('product_id' => $value->product_id));
            }
            else{
                $unit_primary = $this->product_sale->get_unit_primary($value->product_id);
                $wholesale_list = array('quantity' => $value->quantity,
                                        'unit' => $unit_primary->id,
                                        'product_id' => $value->product_id);
                $this->wholesale->insert($wholesale_list);
            }
        }
        echo json_encode($wholesale);
    }
}