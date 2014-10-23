<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Product_sale_price extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('products_sale_price_model','sale_price');
    }
    public function index() {
        $product_id = $_GET['product_id'];
        $sale_price = $this->sale_price->get_by_product_id($product_id);
        echo json_encode($sale_price);
    }
    
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */