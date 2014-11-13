<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Warehouses extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('warehouses_model','warehouses');
    }
    public function index() {
        $warehouses = $this->warehouses->get_all();
        echo json_encode(array('warehouses' => $warehouses));
    }
    public function getWarehouse($warehouses_id){
        $warehouse = $this->warehouses->get_by_id($warehouses_id);
        echo json_encode(array('warehouse' => $warehouse));
    }
    public function addWarehouse(){
        $warehouse = $this->input->json();
        $warehouses_id = $this->warehouses->insert($warehouse);
        echo json_encode($warehouses_id);
    }
}

