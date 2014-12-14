<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Order extends CI_Controller {
    public function __construct() {
        parent::__construct();
        $this->load->model('customers_model','customers');
        $this->load->model('order_model','order');
    }
    public function createOrder(){
        $type = $this->input->get('type');
        $customers = $this->customers->get_all_customer_by_type($type);
        
        #get products
        $this->load->model('products_model');
        $products = $this->products_model->get_all_order('order');
        
        #get unit
        $this->load->model('products_sale_price_model','products_sale');
        $unit = $this->products_sale->get_all();
        echo json_encode(array('customers' => $customers,'products' => $products,'units' => $unit));
    }
    public function addOrder(){
        $order = $this->input->json();
        $this->load->model('order_detail_model','order_detail');
        $order_id = $this->order->insert(array('customer_id' => $order->customer_id,'total_price' => $order->total_price));
        foreach($order->orders as $key => $row){
            $order->orders[$key]->order_id = $order_id;
            $this->order_detail->insert($row);
        }
        echo json_encode('success');
    }
    public function managementOrder(){
        $orders = $this->order->get_all();
        echo json_encode(array('orders' => $orders));
    }
    public function createShipment(){
        $shipment = $this->input->json();
        $this->load->model('shipments_model','shipment');
        $data_insert = array('truck_id' => $shipment->truck,
                             'driver' => $shipment->driver,
                             'sub_driver' => $shipment->sub_driver);
        $shipment_id = $this->shipment->insert($data_insert);
        foreach($shipment->shipments as $key => $row){
            $this->order->update(array('shipment_id' => $shipment_id),array('id' => $row->id));
        }
        echo json_encode(array('shipment_id' =>$shipment_id));
    }
    public function divideOrder(){
        $shipment_id = $this->input->get('shipment_id');
        $this->load->model('order_detail_model','order_detail');
        $this->load->model('warehouses_detail_model','warehouses_detail');
        $this->load->model('warehouse_wholesale_model','warehouse_wholesale');
        #get orders
        $orders = $this->order->get_array(array('shipment_id' => $shipment_id));
        $order_detail = array_map(function($order){
            return $order->id;
        },$orders);
        $order_detail = implode(',', $order_detail);
        $order_detail = $this->order_detail->get_order_detail($order_detail);
        $arr = array();
        foreach ($order_detail as $key => $row){
            if(isset($arr[$row->product_id]))
                $arr[$row->product_id]['quantity'] += (int)$row->quantity;
            else{
                $arr[$row->product_id] = array('product_name' => $row->product_name,
                                               'quantity' => (int)$row->quantity,
                                               'warehouse' => $this->warehouses_detail->get_array(array('product_id' => $row->product_id)));
                $wholse = $this->warehouse_wholesale->get_by_product_id($row->product_id);
                if(count($wholse) > 0)
                    $arr[$row->product_id]['warehouse'][] = array('id' => 0,'warehouses_id' => 0,'warehouses_name' => 'kho sỉ','quantity' => $wholse->quantity);
            }
        }
        echo json_encode(array('orders' =>$orders,'products' => $arr));
    }
}
?>