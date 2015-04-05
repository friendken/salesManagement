<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Warehouse_retail_sale extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('bill_model','bill');
        $this->load->model('products_sale_price_model','product_sale');
        $this->load->model('products_buy_price_model','product_buy');
        $this->load->model('warehouse_retail_model','retail');
        $this->load->model('bill_detail_model','bill_detail');
    }
    public function index(){
        $bills = $this->bill->get_all_by_type('retail');
        echo json_encode(array('bills' => $bills));
    }
    public function getPrice(){
        $id = $_GET['id'];
        $price = $this->product_sale->get_by_id($id);
        echo json_encode($price);
    }
    public function createBill(){
        $bill = $this->input->json();

        #create bill
        $data_bill = array('customer_id' => $bill->partner,
                           'warehouse' => 'retail',
                           'debit' => $bill->debt,
                           'price_total' => $bill->total_bill);

        $bill_id = $this->bill->insert($data_bill);
        $new_bill = $this->bill->get_by_id($bill_id);
        $code_bill = 'L'.$new_bill->id;
        $this->bill->update(array('bill_code' => $code_bill),array('id' => $bill_id));
        #create bill detail
        $bill_detail = array();
        foreach($bill->buy_price as $key => $row){
            $this->load->library('convert_unit');
            $quantity = $this->convert_unit->convert_quantity($row->unit,$row->quantity);
            $bill_detail = array('bill_id' => $bill_id,
                                 'product_id' => $row->product_id,
                                 'quantity' => $quantity,
                                 'price' => $row->price);
            $this->bill_detail->insert($bill_detail);
            #update quantity of product
            $update_warehouse = $this->updateQuantityWarehouse($row->product_id, $quantity);
            if($update_warehouse == true){
                $this->updateQuantityBuy($row->product_id,$row->quantity);
            }
        }
        echo json_encode($code_bill);
    }
    public function updateQuantityBuy($product_id, $quantity){
        $product_buy = $this->product_buy->get_old_product($product_id,'retail');
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
        $product_retail = $this->retail->get_by_product_id($product_id);
        if(count($product_retail) > 0){
            if($product_retail->quantity >= $quantity){
                $this->retail->update(array('quantity' => ((int)$product_retail->quantity - (int)$quantity)),array('id' => $product_retail->id));
                return true;
            }
        }
        return false;
    }
}