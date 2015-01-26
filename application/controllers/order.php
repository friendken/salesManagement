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
        $this->load->model('bill_model','bill');
        foreach($customers as $key => $row){
            $customers[$key]->total_debt = $this->bill->get_customer_debit($row->id);
        }
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
            $this->load->model('products_sale_price_model','products_sale');
            $order->orders[$key]->order_id = $order_id;
            $this->order_detail->insert($row);
        }
        echo json_encode('success');
    }
    public function managementOrder(){
        $this->load->model('trucks_model','trucks');
        $this->load->model('staff_model','staff');
        $orders = $this->order->get_all();
        $trucks = $this->trucks->get_array(array('active' => 0));
        $staffs = $this->staff->get_array(array('active' => 0));
        echo json_encode(array('orders' => $orders,'trucks' => $trucks,'staffs' => $staffs));
    }
    public function createShipment(){
        $shipment = $this->input->json();
        $this->load->model('shipments_model','shipment');
        $data_insert = array('truck_id' => $shipment->truck,
                             'driver' => $shipment->driver,
                             'sub_driver' => $shipment->sub_driver);
        $shipment_id = $this->shipment->insert($data_insert);
        foreach($shipment->shipments as $key => $row){
            if($row->status == 5)
                $this->shipment->update(array('status' => '3'),array('id' => $row->shipment_id));
            $this->order->update(array('shipment_id' => $shipment_id),array('id' => $row->id));
        }
        echo json_encode(array('shipment_id' =>$shipment_id));
    }
    public function divideOrder(){
        $shipment_id = $this->input->get('shipment_id');
        $this->load->model('order_detail_model','order_detail');
        $this->load->model('warehouses_detail_model','warehouses_detail');
        $this->load->model('warehouse_wholesale_model','warehouse_wholesale');
        $this->load->model('shipments_model');
        $this->load->model('products_sale_price_model','sale_price');
        $this->load->library('convert_unit');
        $this->load->model('warehouse_retail_model','warehouse_retail');

        $shipment = $this->shipments_model->get_by_id($shipment_id);
        #get orders
        $orders = $this->order->get_array(array('shipment_id' => $shipment_id));
        $order_detail = array();
        foreach($orders as $key => $row){
            if($row->status != 5)
                array_push($order_detail,$row->id);
        }
        
        $order_detail = implode(',', $order_detail);
        $order_detail = $this->order_detail->get_order_detail($order_detail);
        $arr = array();
        
        foreach ($order_detail as $key => $row){
            $unit_primary = $this->sale_price->get_unit_primary($row->product_id);
            if($unit_primary && $unit_primary->id != $row->unit) {
                $quantity = $this->convert_unit->convert_quantity($row->unit, $row->quantity);
                $retail = $this->warehouse_retail->get_by_product_id($row->product_id);
                if(count($retail) > 0)
                    $this->warehouse_retail->update(array('quantity' => ((int)$retail->quantity - (int)$quantity)),array('product_id' => $row->product_id));
                else
                    $this->warehouse_retail->insert(array('quantity' => $quantity,'product_id' => $row->product_id,'unit' => $row->unit));
            }else{
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
        }
        echo json_encode(array('orders' =>$orders,'products' => $arr,'shipment' => $shipment));
    }
    public function updateWarehouse(){
        $warehouses = $this->input->json();
        $ship_id = $this->input->get('ship_id');
        #update quantity
        $this->load->model('warehouses_detail_model','warehouses_detail');
        $this->load->model('warehouse_wholesale_model','warehouse_wholesale');
        foreach ($warehouses as $key => $row){
            if($row->warehouses_id != 0){
                $warehouse = $this->warehouses_detail->get_product_storge($row->product_id,$row->warehouses_id);
                $this->warehouses_detail->update(array('quantity' => ((int)$warehouse->quantity) - (int)$row->quantity),array('id' => $warehouse->id));
            }else{
                $wholesale = $this->warehouse_wholesale->get_by_product_id($row->product_id);
                $this->warehouse_wholesale->update(array('quantity' => ((int)$wholesale->quantity - (int)$row->quantity)),array('id' => $wholesale->id));
            }
        }
        $this->load->model('shipments_model');
        $this->shipments_model->update(array('allow' => '1'),array('id' => $ship_id));
        echo json_encode($warehouses);
    }
    public function statusOrder(){
        $this->load->model('shipments_model','shipment');
        $this->load->model('order_status_type_model','order_status');
        $shipments = $this->shipment->get_array(array('status !=' => '3'));
        echo json_encode(array('shipments' => $shipments));
    }
    public function updateStatusShipment(){
        $shipment_id = $this->input->get('shipment_id');
        $status = $this->input->get('status');
        
        #update shipment
        $this->load->model('shipments_model','shipments');
        $this->shipments->update(array('status' => "$status"),array('id' => $shipment_id));
        #update order
        $this->load->model('order_model','order');
        $this->order->update(array('status' => 1),array('shipment_id' => $shipment_id));
    }
    public function updateOrder(){
        $order_id = $this->input->get('order_id');
        $this->order->update(array('status' => 5),array('id' => $order_id));
        echo json_encode($order_id);
    }
    public function returnWarehouse(){
        $order_id = $this->input->get('order_id');
        $this->load->model('warehouses_model');
        $this->load->model('order_detail_model','order_detail');
        $this->load->model('products_sale_price_model','sale_price');
        $order = $this->order_detail->get_order_detail($order_id);
//        echo json_encode($order);die;
        $warehouses = $this->warehouses_model->get_all();
        $wholesale = array();
        $retail = array();
        foreach($order as $key => $row){
            $unit = $this->sale_price->get_unit_retail($row->product_id);
            if($unit->id == $row->unit){
                array_push($retail,$row);
//                $this->load->model('warehouse_retail_model','warehouse_retail');
//                $retail = $this->warehouse_retail->get_by_product_id($row->product_id);
//                if(count($retail) > 0)
//                    $this->warehouse_retail->update(array('quantity' => ((int)$retail->quantity + (int)$row->quantity)),array('product_id' => $row->product_id));
//                else
//                    $this->warehouse_retail->insert(array('quantity' => $row->quantity,
//                                                          'product_id' => $row->product_id,
//                                                          'unit' => $row->unit));
            }else{
                $row->warehouse = $warehouses;
                array_push($wholesale, $row);
            }
        }
//        if(count($wholesale) == 0){
//            $this->order->update(array('status' => '4','delivery' => '1'),array('id' => $order_id));
//            $shipment = $this->order->get_array(array('shipment_id' => $order_id,'delivery' => '0'));
//            if(count($shipment) != 0){
//                $this->load->model('shipments_model');
//                $this->shipments_model->update(array('status' => '3'),array('id' => $shipment->id));
//            }
//        }
        echo json_encode(array('order' => $wholesale,'retail' => $retail));
    }
    public function getRestOrder(){
        $truck_id = $this->input->get('truck_id');
        $orders = $this->order->getRestOrder($truck_id);
        echo json_encode(array('orders' => $orders));
    }
    public function getReturnWarehouse(){
        $data = $this->input->json();
        $order_id = $this->input->get('order_id');
        $this->load->model('warehouses_detail_model','warehouses_detail');
        $this->load->model('warehouse_retail_model','warehouse_retail');
        $product = $data->product;
        #return warehouse whole
        foreach($product as $key => $row){
            $warehouse = $this->warehouses_detail->get_product_storge($row->product_id, $row->warehouses_id);
            if(count($warehouse) > 0)
                $this->warehouses_detail->update(array('quantity' => ((int)$warehouse->quantity + (int)$row->quantity)),array('id' => $warehouse->id));
            else
                $this->warehouses_detail->insert(array('product_id' => $row->product_id,'warehouses_id' => $row->warehouses_id,'quantity' => $row->quantity));
        }
        #return retail warehouse
        $retail = $data->retail;
        foreach($retail as $key => $row){
            $retail_product = $this->warehouse_retail->get_by_product_id($row->product_id);
            if(count($retail_product) > 0)
                $this->warehouse_retail->update(array('quantity' => ((int)$retail_product->quantity + (int)$row->quantity)),array('product_id' => $row->product_id));
            else
                $this->warehouse_retail->insert(array('product_id' => $row->product_id,'quantity' => $row->quantity));
        }
        
        $orders = $this->order->get_array(array('id' => $order_id));
        
        $this->order->update(array('delivery' => '1','status' => '4'),array('id' => $order_id));
        $shipment = $this->order->get_array(array('shipment_id' => $orders[0]->shipment_id,'delivery' => '0'));
        if(count($shipment) == 0){
            $this->load->model('shipments_model');
            $this->shipments_model->update(array('status' => '3'),array('id' => $orders[0]->shipment_id));
        }
        echo json_encode($product);
    }
}
?>