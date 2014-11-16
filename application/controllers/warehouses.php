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
        $warehouse->storge = json_encode(array());
        $warehouses_id = $this->warehouses->insert($warehouse);
        echo json_encode($warehouses_id);
    }
    public function getWarehouseStorge(){
        $warehouses_id = $this->input->get('id');
        $this->load->model('warehouses_detail_model','warehouse_detail');
        $this->load->model('products_sale_price_model','products_sale');
        $storge = $this->warehouse_detail->get_warehouse_storge($warehouses_id);
        $i = 1;
        foreach ($storge as $key => $row){
            $storge[$key]->stt = $i;
            $storge[$key]->unit = $this->products_sale->get_unit_primary($row->product_id);
            $i++;
        }
        echo json_encode(array('warehouses' => $storge));
    }
    public function getProductOutOfStorge(){
        $this->load->model('warehouses_detail_model','warehouse_detail');
        $products = $this->warehouse_detail->get_product_out_of_storge();
        $i = 1;
        foreach ($products as $key => $row){
            $products[$key]->stt = $i;
            $i++;
        }
        echo json_encode(array('products' => $products));
    }
}

