<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Warehouses extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('warehouses_model','warehouses');
        $this->load->model('products_model','products');
    }
    public function index() {
        $data = $this->warehouses->get_all();
        echo json_encode(array('warehouses' => $data));
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
        $this->load->model('warehouse_wholesale_model','warehouse_wholesale');
        if($warehouses_id != 0)
            $storge = $this->warehouse_detail->get_warehouse_storge($warehouses_id);
        else
            $storge = $this->warehouse_wholesale->get_all();

        foreach ($storge as $key => $row){
            $storge[$key]->unit = $this->products_sale->get_unit_primary($row->product_id);
            if(isset($row->name))
                $storge[$key]->product_name = $row->name;
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
    public function getAllWarehouses(){
        $this->load->model('warehouses_detail_model','warehouse_detail');
        $this->load->model('products_model','products');
        $warehouses = $this->warehouse_detail->get_warehouse_status();
        $products = $this->products->get_array(array('active' => 0));
        echo json_encode(array('warehouses' => $warehouses, 'products' => $products));
    }
}

