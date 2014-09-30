<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Product_type extends CI_Controller {

    public function index() {
        echo 'ok';
    }
    public function createProductType(){
        $product = $this->input->json();
        echo json_encode($product);
    }
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */