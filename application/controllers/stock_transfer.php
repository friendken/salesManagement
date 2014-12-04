<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Stock_transfer extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('warehouse_retail_model','retail');
        $this->load->model('products_sale_price_model','sale_price');
        $this->load->model('warehouse_wholesale_model','wholesale');
    }
    public function index(){
        $wholesale_products = $this->wholesale->get_all();
        $retail_prodcuts = $this->retail->get_all();
        echo json_encode(array('wholesale_products' => $wholesale_products,'retail_products' => $retail_prodcuts));
    }
    public function doTransfer(){
        $transfer = $this->input->json();
        $sale_price = $this->sale_price->get_by_product_id($transfer->product_id);
        $quantity = 1;
        //======= update quantity in wholesale warehouse =======
        $wholesale_product = $this->wholesale->get_by_product_id($transfer->product_id);
        $new_quantity = (int)$wholesale_product->quantity - $transfer->quantity;
        $this->wholesale->update(array('quantity' => $new_quantity),array('product_id' => $transfer->product_id));
        
        
        foreach($sale_price as $key => $row){
            $transfer->quantity *= (int)$row->quantity;
        }
        //====== update quantity in retail warehouse ======
        $retail_product = $this->retail->get_by_product_id($transfer->product_id);
        if(count($retail_product) > 0 ){
            $this->retail->update(array('quantity' => ($transfer->quantity + $retail_product->quantity)),array('product_id' => $retail_product->product_id));
        }else{
            $unit_retail = $this->sale_price->get_unit_retail($transfer->product_id);
            $this->retail->insert(array('product_id' => $transfer->product_id,'quantity' => $transfer->quantity,'unit' => $unit_retail->id));
        }
        
        echo json_encode($transfer->quantity);
    }
    public function initWarehousesTransfer(){
        $this->load->model('warehouses_model');
        $warehouses = $this->warehouses_model->get_all();
        array_push($warehouses, array('id' => 0,'name' => 'kho sỉ'));
        echo json_encode(array('warehouses' => $warehouses));
    }
    public function saveWarehouseTransfer(){
        $data = $this->input->json();
        $this->load->model('warehouses_detail_model');
        $this->load->model('export_bill_model');
        $this->load->model('export_detail_model');
        $this->load->model('warehouse_wholesale_model');
        
        #create export bill
        $export_id = $this->export_bill_model->insert(array('warehouse_from' => $data->warehouse_from, 'warehouse_to' => $data->warehouse_to));
        foreach($data->transfer as $key => $row){
            #update product in warehouse form
            if($data->warehouse_from != 0)
                $this->warehouses_detail_model->update(array('quantity' => $row->remaining),array('product_id' => $row->product_id,'warehouses_id' => $data->warehouse_from));
            else
                $this->warehouse_wholesale_model->update(array('quantity' => $row->remaining),array('product_id' => $row->product_id));
            #update product in warehouse to
            if($data->warehouse_to != 0){
                $product = $this->warehouses_detail_model->get_product_storge($row->product_id,$data->warehouse_to);
                if(count($product) > 0)
                    $this->warehouses_detail_model->update(array('quantity' => ((int)$product->quantity + (int)$row->quantity)),array('id' => $product->id));
                else
                    $this->warehouses_detail_model->insert(array('quantity' => ((int)$row->quantity),'warehouses_id' => $data->warehouse_to,'product_id' => $row->product_id));
            }else{
                $product = $this->warehouse_wholesale_model->get_by_product_id($row->product_id);
                if(count($product) > 0)
                    $this->warehouse_wholesale_model->update(array('quantity' => ((int)$product->quantity + (int)$row->quantity)),array('id' => $product->id));
                else
                    $this->warehouse_wholesale_model->insert(array('quantity' => ((int)$row->quantity),'product_id' => $row->product_id));
            }
            #insert export detail
            $this->export_detail_model->insert(array('export_id' => $export_id,'product_id' => $row->product_id, 'quantity' => $row->quantity));
        }
        
        echo json_encode($data);
    }
    public function getExport(){
        $this->load->model('export_bill_model');
        $export = $this->export_bill_model->get_all();
        $i = 1;
        foreach ($export as $key => $row){
            $export[$key]->stt = $i;
            $i++;
        }
        echo json_encode(array('export' => $export));
    }
    public function getExportDetail(){
        $id = $this->input->get('id');
        $this->load->model('export_bill_model');
        $export = $this->export_bill_model->get_by_id($id);
        echo json_encode(array('exports' => $export));
    }
}
?>