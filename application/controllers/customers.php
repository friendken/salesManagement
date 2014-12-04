<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Customers extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('customers_model','customers');
    }
    public function index() {
        $type = $this->input->get('type');
        $customers = $this->customers->get_all_customer_by_type($type);
        echo json_encode(array('customers' => $customers));
    }
    public function createCustomer(){
        $customer = $this->input->json();
        $customer_id = $this->customers->insert($customer);
        echo json_encode($customer_id);
    }
    
}
?>
