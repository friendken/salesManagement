<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Product_type extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('products_type_model','product_type');
    }
    public function index() {
        $product = $this->product_type->get_all();
        echo json_encode($product);
    }
    public function createProductType(){
        $product = $this->input->json();
        $id = $this->product_type->insert($product);
        echo json_encode($product);
    }
    public function updateProductType(){
        $product = $this->input->json();
        $this->product_type->update(array('name' => $product->name),array('id' => $product->id));
    }
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */