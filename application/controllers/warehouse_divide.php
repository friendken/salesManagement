<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Warehouse_divide extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('warehousing_model','warehousing');
        $this->load->model('products_model','product');
        $this->load->model('warehouses_detail_model','warehouses_detail');
        $this->load->model('warehouses_model','warehouses');
        $this->load->model('warehousing_history_model','warehousing_history');
        $this->load->model('products_buy_price_model','product_buy');
        $this->load->model('products_sale_price_model','product_sale');
        
    }
    public function index(){
        $warehousing_id = $this->input->get('id');
        $product = $this->product_buy->get_array('warehousing_id',$warehousing_id);
        $warehousing = $this->warehousing->get_by_id($warehousing_id);
        $warehouses = $this->warehouses->get_all();
        $i = 1;
        foreach($product as $key => $row){
            $product[$key]->detail = $this->product->get_by_id($row->product_id);
            $product[$key]->unit = $this->product_sale->get_by_id($row->unit);
            $product[$key]->stt = $i;
            $i++;
        }
        echo json_encode(array('products' => $product,'warehouses' => $warehouses,'warehousing' => $warehousing));
    }
    public function updateStorge(){
        $data = $this->input->json();
        $storge = $data->list;
        
        foreach ($storge as $key => $value){
            if($key != 0){
                foreach ($value as $item => $row){
                    $product = $this->warehouses_detail->get_product_storge($row->product_id,$key);
                    #insert or update warehouses detail
                    if(!$row->quantity || $row->quantity == '' ) $row->quantity = 0;
                    if($row->quantity != 0){
                        if(count($product) > 0)
                            $this->warehouses_detail->update(array('quantity' => ((int)$product->quantity + (int)$row->quantity)),array('id' => $product->id));
                        else
                            $this->warehouses_detail->insert(array('product_id' => $row->product_id,'warehouses_id' => $key,'quantity' => (int)$row->quantity));
                    }
                    #insert warehousing hitory
                    $this->warehousing_history->insert(array('product_id' => $row->product_id,
                                                             'warehouses_id' => $key,
                                                             'warehousing_id' => $data->warehousing_id,
                                                             'quantity' => $row->quantity));
                }
            }
        }
        #update allow access for warehousing
        $this->warehousing->update(array('allow' => '1'),array('id' => $data->warehousing_id));
        
        

    }
}