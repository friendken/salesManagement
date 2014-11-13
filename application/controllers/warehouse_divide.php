<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Warehouse_divide extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('warehousing_model','warehousing');
        $this->load->model('products_model','product');
        $this->load->model('warehouses_model','warehouses');
        $this->load->model('products_buy_price_model','product_buy');
        $this->load->model('products_sale_price_model','product_sale');
        
    }
    public function index(){
        $warehousing_id = $this->input->get('id');
        $warehousing = $this->product_buy->get_array('warehousing_id',$warehousing_id);
        $warehouses = $this->warehouses->get_all();
        $i = 1;
        foreach($warehousing as $key => $row){
            $warehousing[$key]->detail = $this->product->get_by_id($row->product_id);
            $warehousing[$key]->unit = $this->product_sale->get_by_id($row->unit);
            $warehousing[$key]->stt = $i;
            $i++;
        }
        echo json_encode(array('products' => $warehousing,'warehouses' => $warehouses));
    }
    public function updateStorge(){
        $storge = $this->input->json();
        foreach ($storge as $key => $value){
            if($key != 0){
                $warehouse = $this->warehouses->get_by_id($key);
                var_dump($warehouse);
            }
        }
//        echo json_encode($storge);
    }
}