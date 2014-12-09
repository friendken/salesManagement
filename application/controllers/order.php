<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Order extends CI_Controller {
    public function __construct() {
        parent::__construct();
        $this->load->model('customers_model','customers');
    }
    public function createOrder(){
        $type = $this->input->get('type');
        $customers = $this->customers->get_all_customer_by_type($type);
        
        #get products
        $this->load->model('products_model');
        $products = $this->products_model->get_all_order('order');
        
        #get unit
        $this->load->model('products_sale_price_model','products_sale');
        $unit = $this->products_sale->get_all();
        echo json_encode(array('customers' => $customers,'products' => $products,'units' => $unit));
    }
}
?>