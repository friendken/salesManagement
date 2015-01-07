<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Warehouse_wholesale_sale extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('bill_model','bill');
        $this->load->model('products_sale_price_model','product_sale');
        $this->load->model('products_buy_price_model','product_buy');
        $this->load->model('warehouse_wholesale_model','wholesale');
        $this->load->model('bill_detail_model','bill_detail');
    }
    public function index(){
        $bills = $this->bill->get_all_by_type('wholesale');
        echo json_encode(array('bills' => $bills));
    }
    public function getPrice(){
        $id = $_GET['id'];
        $price = $this->product_sale->get_by_id($id);
        echo json_encode($price);
    }
    public function createBill($bill = null, $from = null){
        if(!isset($bill))
            $bill = $this->input->json();
        $code_bill = strtoupper(substr(md5(time()),0,6));
        
        #create bill
        $data_bill = array('bill_code' => $code_bill,
                           'customer_id' => $bill->partner,
                           'price_total' => $bill->total_bill);
        if(isset($bill->debt))
            $data_bill['debit'] = $bill->debt;
        
        $bill_id = $this->bill->insert($data_bill);
        #create bill detail
        $bill_detail = array();
        foreach($bill->buy_price as $key => $row){
            $bill_detail = array('bill_id' => $bill_id,
                                 'product_id' => $row->product_id,
                                 'quantity' => $row->quantity,
                                 'price' => $row->price);
            $this->bill_detail->insert($bill_detail);
            #update quantity of product
            if(!isset($from)){
                $update_warehouse = $this->updateQuantityWarehouse($row->product_id, $row->quantity);
                if($update_warehouse == true){
                    $this->updateQuantityBuy($row->product_id,$row->quantity);
                }
            }
        }
//        echo $bill_id;
    }
    public function updateQuantityBuy($product_id, $quantity){
        $product_buy = $this->product_buy->get_old_product($product_id,'wholesale');
        
        if(count($product_buy) > 0){
            if($product_buy->remaining_quantity >= $quantity)
                $this->product_buy->update(array('remaining_quantity' => ((int)$product_buy->remaining_quantity - (int)$quantity)),array('id' => $product_buy->id));
            else{
                $this->product_buy->update(array('remaining_quantity' => 0),array('id' => $product_buy->id));
                $remaining = (int)$quantity - (int)$product_buy->remaining_quantity;
                $this->updateQuantityBuy($product_id, $remaining);
            }
        }
    }
    public function updateQuantityWarehouse($product_id,$quantity){
        $product_wholesale = $this->wholesale->get_by_product_id($product_id);
        if(count($product_wholesale) > 0){
            if($product_wholesale->quantity >= $quantity){
                $this->wholesale->update(array('quantity' => ((int)$product_wholesale->quantity - (int)$quantity)),array('id' => $product_wholesale->id));
                return true;
            }
        }
        return false;
    }
    
    public function createBillFromOrder(){
        $data = $this->input->json();
        $this->load->model('order_model','order');
        $order = $this->order->get_by_id($data->order_id);
        $data_inset = array('partner' => $order->customer_id,
                            'total_bill' => $order->total_price);
        
        if($data->price != ''){
            if((int)$order->total_price - (int)$data->price != 0)
                $data_inset['debt'] = (int)$order->total_price - (int)$data->price;
        }
        
        #init array for order detail
        foreach($order->order_detail as $key => $row){
            $data_inset['buy_price'][] = (object)array('product_id' => $row->product_id,
                                                        'quantity' => $row->quantity,
                                                        'price' => $row->total);
        }
        
        $this->createBill((object)$data_inset,true);
        $this->order->update(array('delivery' => "1"),array('id' => $data->order_id));
        $shipment = $this->order->get_array(array('shipment_id' => $data->shipment_id,'delivery' => '0'));
        if(count($shipment) == 0){
            $this->load->model('shipments_model');
            $this->shipments_model->update(array('status' => '3'),array('id' => $data->shipment_id));
        }
        echo json_encode($data_inset);
    }
}