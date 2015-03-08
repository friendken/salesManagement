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
        $this->load->model('bill_model','bill');
    }
    public function index(){
        $products = $this->wholesale->get_all();
        $this->load->model('customers_model','customers');
        $customers = $this->customers->get_array(array('type' => 'customer','active' => 0));
        foreach($customers as $key => $row){
            $customers[$key]->total_debt = $this->bill->get_customer_debit($row->id);
        }
        echo json_encode(array('products' => $products,'customers' => $customers));
    }
    public function addWholesale(){
        $products = $this->product->get_array(array('active' => '0'));
        $this->load->model('customers_model','customers');
        $customers = $this->customers->get_array(array('type' => 'partner'));
        echo json_encode(array('products' => $products,'customers' => $customers));
    }
    public function saveAddWholesale(){
        $wholesale = $this->input->json();
        
        #insert warehousing
        $this->load->model('warehousing_model');
        $warehousing_id = $this->warehousing_model->insert(array('price' => $wholesale->total_bill,
                                                                 'debit' => $wholesale->debt));
        #insert product_buy_price
        $buy_list = array();
        $wholesale_list = array();
        foreach($wholesale->buy_price as $item => $value){
            $unit_primary = $this->product_sale->get_unit_primary($value->product_id);
            $buy_list = array('product_id' => $value->product_id,
                              'price' => $value->price,
                              'unit' => $unit_primary->id,
                              'warehousing_id' => $warehousing_id,
                              'quantity' => $value->quantity,
                              'remaining_quantity' => $value->quantity,
                              'partner' => $wholesale->partner);
            $this->product_buy->insert($buy_list);
            #insert or update quantity
            
            $wholesale_product = $this->wholesale->get_by_product_id($value->product_id);
            
            if(count($wholesale_product) > 0){
                $wholesale_list = array('quantity' => ((int)$value->quantity + (int)$wholesale_product->quantity));
                $this->wholesale->update($wholesale_list,array('product_id' => $value->product_id));
            }
            else{
                
                $wholesale_list = array('quantity' => $value->quantity,
                                        'unit' => $unit_primary->id,
                                        'product_id' => $value->product_id);
                $this->wholesale->insert($wholesale_list);
            }
        }
        echo json_encode($warehousing_id);
    }
}