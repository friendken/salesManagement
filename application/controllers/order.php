<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Order extends CI_Controller {
    public function __construct() {
        parent::__construct();
        $this->load->model('customers_model','customers');
        $this->load->model('order_model','order');
    }
    public function deleteOrder($order_id){
        $this->load->model('order_detail_model','order_detail');
        $this->order->delete(array('id' => $order_id));
        $this->order_detail->delete(array('order_id' => $order_id));
    }
    public function updateQuantityOrder(){
        $data = $this->input->json();
        $this->load->model('order_detail_model','order_detail');

        foreach ($data as $key => $row){
            $order_detail = $this->order_detail->get_by_id($row->order_id);
            $this->order_detail->update(array('quantity' => $row->quantity,'total' => ((int)$order_detail->price * (int)$row->quantity)),array('id' => $row->order_id));
            $this->order->updatePriceOfOrder($order_detail->order_id);
        }
        echo json_encode(array('status' => 'success'));
    }
    public function deleteProductInOrder($shipment_id,$product_id){
        $this->load->model('order_detail_model','order_detail');
        $this->order_detail->delete_by_shipment($shipment_id,$product_id);
    }
    public function updateOrderDetail(){
        $data = $this->input->json();
        $orders = $data->order_detail;
        $order_id = $this->input->get('order_id');
        $this->load->model('order_detail_model','order_detail');
        #delete all order detail
        $this->order_detail->delete_by_order_id($order_id);
        
        #insert new order detail
        $total_order = 0;
        foreach($orders as $key => $row){
            $order_insert = array('order_id' => $order_id,
                                  'product_id' => $row->product_id,
                                  'quantity' => $row->quantity,
                                  'unit' => $row->unit,
                                  'cost' => $row->cost,
                                  'price' => $row->price,
                                  'total' => $row->total);
            $this->order_detail->insert($order_insert);
            $total_order += (int)$row->total;
        }
        
        #update total price of bill
        $this->order->update(array('total_price' => $total_order,'note' => $data->note),array('id' => $order_id));
        echo json_encode('ok');
    }
    public function getInventory(){
        $unit_id = $this->input->get('unit');
        
        #load model
        $this->load->model('products_model','products');
        $this->load->model('products_sale_price_model','products_sale');
        $this->load->model('warehouse_retail_model','retail');
        $this->load->model('warehouse_wholesale_model','wholesale');
        $this->load->model('warehouses_detail_model','warehouses_detail');
        
        #get inventory
        $quantity = 0;
        $unit = $this->products_sale->get_by_id($unit_id);
        $total_unit = $this->products_sale->get_by_product_id($unit->product_id);
        
        if($unit->parent_id == null && count($total_unit) > 0){
            $warehouses_count = $this->warehouses_detail->count_product_all_warehouses($unit->product_id);
            
            $wholesale = $this->wholesale->get_by_product_id($unit->product_id);
            $warehouses_count->total?$warehouses_count = (int)$warehouses_count->total:$warehouses_count = 0;
            count($wholesale) > 0?$wholesale = (int)$wholesale->quantity:$wholesale = 0;
            $quantity = $warehouses_count + $wholesale;
        }else{
            $retail = $this->retail->get_by_product_id($unit->product_id);
            count($retail) > 0?$retail = $retail->quantity:$retail = 0;
            $quantity = $retail;
        }
        $product_detail = $this->products->get_by_id($unit->product_id);
        $product_detail->inventory = $quantity;
        
        echo json_encode(array('product_detail' => $product_detail,'unit_detail' => $unit));
    }
    public function index(){
        $order = $this->order->get_array(array('status' => 2),true);
        echo json_encode(array('orders' => $order));
    }
    public function addProductPopup(){
        $this->load->model('products_model','products');
        $this->load->model('products_sale_price_model','sale_price');
        $products = $this->products->get_all_order('order');
        $units = $this->sale_price->get_all();
        echo json_encode(array('products' => $products,'units' => $units));
    }
    public function getProductOrder($shipment_id,$product_id){
        $this->load->model('order_detail_model','order_detail');
        $orders = $this->order->get_array(array('shipment_id' => $shipment_id));
        $order_product = array();
        foreach ($orders as $key => &$row){
            $order_detail = $this->order_detail->get_array(array('order_id' => $row->id,'product_id' => $product_id));
            if(count($order_detail) > 0){
                $row->customer_detail = $this->customers->get_by_id($row->customer_id);
                $row->order_detail = $order_detail[0];
                array_push($order_product, $row);
            }
        }
        echo json_encode(array('orders' => $order_product));die;
    }
    public function getOrder(){
        $order_id = $this->input->get('id');
        $this->load->model('bill_model','bill');
        $order = $this->order->get_by_id($order_id);
        $order->customer_detail = $this->customers->get_by_id($order->customer_id);
        $order->customer_detail->debit = $this->bill->get_customer_debit($order_id);
        
        #get product detail
        $this->load->model('products_model','products');
        $this->load->model('products_sale_price_model','products_sale');
        $this->load->model('warehouse_retail_model','retail');
        $this->load->model('warehouse_wholesale_model','wholesale');
        $this->load->model('warehouses_detail_model','warehouses_detail');
        foreach($order->order_detail as $key => $row){
            $order->order_detail[$key]->product_detail = $this->products->get_by_id($row->product_id);
            $order->order_detail[$key]->unit_detail = $this->products_sale->get_by_id($row->unit);
            $total_unit = $this->products_sale->get_by_product_id($row->product_id);
            if($order->order_detail[$key]->unit_detail->parent_id == null && count($total_unit) > 0){
                $warehouses_count = $this->warehouses_detail->count_product_all_warehouses($row->product_id);
                $wholesale = $this->wholesale->get_by_product_id($row->product_id);
                $warehouses_count->total?$warehouses_count = (int)$warehouses_count->total:$warehouses_count = 0;
                count($wholesale) > 0?$wholesale = (int)$wholesale->quantity:$wholesale = 0;
                $order->order_detail[$key]->product_detail->inventory = $warehouses_count + $wholesale;
            }else{
                $retail = $this->retail->get_by_product_id($row->product_id);
                count($retail) > 0?$retail = $retail->quantity:$retail = 0;
                $order->order_detail[$key]->product_detail->inventory = $retail;
            }
        }
        
        echo json_encode(array('order' =>$order));
        
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
        $order_id = $this->order->insert(array('customer_id' => $order->customer_id,
                                               'total_price' => $order->total_price,
                                               'note' => $order->note));
        $order_code = $this->convertBillCode($order_id,'CH');
        $this->order->update(array('order_code' => $order_code),array('id' => $order_id));
        foreach($order->orders as $key => $row){
            $this->load->model('products_buy_price_model','products_buy');
            $cost = $this->products_buy->get_old_product($row->product_id,'wholesale');
            if(count($cost) > 0)
                $row->cost = $cost->id;
            $order->orders[$key]->order_id = $order_id;
            $this->order_detail->insert($row);
        }
        echo json_encode($order_code);
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
        $this->load->model('customers_model','customers');

        $shipment = $this->shipments_model->get_by_id($shipment_id);
        #get orders
        $orders = $this->order->get_array(array('shipment_id' => $shipment_id));
        $orders_temp = $orders;
        $order_detail = array();
        foreach($orders as $key => &$row){
            $row->customer_detail =  $this->customers->get_by_id($row->customer_id);
            $row->order_detail = $this->order_detail->get_array(array('order_id' => $row->id));
            if($row->status != 5)
                array_push($order_detail,$row->id);
        }
        
        $order_detail = implode(',', $order_detail);
        $order_detail = $this->order_detail->get_order_detail($order_detail);
        
        $arr = array();
//        echo json_encode($orders);die;
        foreach ($order_detail as $key => $row){
            
            $unit_primary = $this->sale_price->get_by_product_id($row->product_id);
            
            if(count($unit_primary) > 1 && !isset($unit_primary->parent_id)) {
                if(isset($arr[$row->product_id]))
                    $arr[$row->product_id]['quantity'] += (int)$row->quantity;
                else{
                    $arr[$row->product_id] = array('product_name' => $row->product_name,
                                                    'product_id' => $row->product_id,
                                                    'quantity' => (int)$row->quantity,
                                                    'warehouse' => $this->warehouses_detail->get_array(array('product_id' => $row->product_id)));
                    $wholse = $this->warehouse_wholesale->get_by_product_id($row->product_id);
                    if(count($wholse) > 0)
                        $arr[$row->product_id]['warehouse'][] = array('id' => 0,'warehouses_id' => 0,'warehouses_name' => 'kho sỉ','quantity' => $wholse->quantity);
                }
            }else{
                $quantity = $this->convert_unit->convert_quantity($row->unit, $row->quantity);
                $retail = $this->warehouse_retail->get_by_product_id($row->product_id);
                if(count($retail) > 0)
                    $this->warehouse_retail->update(array('quantity' => ((int)$retail->quantity - (int)$quantity)),array('product_id' => $row->product_id));
                else
                    $this->warehouse_retail->insert(array('quantity' => $quantity,'product_id' => $row->product_id,'unit' => $row->unit));
            }
        }
        
        echo json_encode(array('orders' =>$orders_temp,'products' => $arr,'shipment' => $shipment));
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
        $warehouses = $this->warehouses_model->get_all();
        $wholesale = array();
        foreach($order as $key => $row){
            $unit = $this->sale_price->get_unit_retail($row->product_id);
            $units = $this->sale_price->get_by_product_id($row->product_id);
            if($unit->id == $row->unit || count($units) == 1){
                $this->load->model('warehouse_retail_model','warehouse_retail');
                $retail = $this->warehouse_retail->get_by_product_id($row->product_id);
                if(count($retail) > 0)
                    $this->warehouse_retail->update(array('quantity' => ((int)$retail->quantity + (int)$row->quantity)),array('product_id' => $row->product_id));
                else
                    $this->warehouse_retail->insert(array('quantity' => $row->quantity,
                                                          'product_id' => $row->product_id,
                                                          'unit' => $row->unit));
            }
            else{
                $row->warehouse = $warehouses;
                array_push($wholesale, $row);
            }
        }
        echo json_encode(array('order' => $wholesale));
    }
    public function returnHalfWarehouse(){
        $order_id = $this->input->get('order_id');
        $this->load->model('warehouses_model');
        $this->load->model('order_detail_model','order_detail');
        $this->load->model('products_sale_price_model','sale_price');
        $order = $this->order_detail->get_order_detail($order_id);
        $warehouses = $this->warehouses_model->get_all();
        $wholesale = array();
        $retail = array();
        foreach($order as $key => $row){
            $unit = $this->sale_price->get_unit_retail($row->product_id);
            $units = $this->sale_price->get_by_product_id($row->product_id);
            if($unit->id == $row->unit || count($units) == 1)
                array_push($retail,$row);
            else{
                $row->warehouse = $warehouses;
                array_push($wholesale, $row);
            }
        }
        echo json_encode(array('order' => $wholesale,'retail' => $retail));
    }
    public function getRestOrder(){
        $truck_id = $this->input->get('truck_id');
        $orders = $this->order->getRestOrder($truck_id);
        echo json_encode(array('orders' => $orders));
    }
    public function getReturnWarehouse(){
        $product = $this->input->json();
        $order_id = $this->input->get('order_id');
        $this->load->model('warehouses_detail_model','warehouses_detail');
        foreach($product as $key => $row){
            $warehouse = $this->warehouses_detail->get_product_storge($row->product_id, $row->warehouses_id);
            if(count($warehouse) > 0)
                $this->warehouses_detail->update(array('quantity' => ((int)$warehouse->quantity + (int)$row->quantity)),array('id' => $warehouse->id));
            else
                $this->warehouses_detail->insert(array('product_id' => $row->product_id,'warehouses_id' => $row->warehouses_id,'quantity' => $row->quantity));
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
    public function getReturnHalfWarehouse(){
        $data = $this->input->json();
        
        $order_id = $this->input->get('order_id');
        $this->load->model('warehouses_detail_model','warehouses_detail');
        $this->load->model('warehouse_retail_model','warehouse_retail');
        $this->load->model('bill_model','bill');
        $this->load->model('bill_detail_model','bill_detail');
        $bill_detail = $this->bill->getLastBill();
//        echo json_encode($data);die;
        $product = $data->product;
        
        #update bill
        
        $this->bill->update(array('debit' => $data->debit,'price_total' => (int)$data->price + (int)$data->debit),array('id' => (int)$bill_detail[0]->bill_id));
        
        #return warehouse whole
        $product_sum_quantity = array();
        foreach($product as $key => $row){
            $warehouse = $this->warehouses_detail->get_product_storge($row->product_id, $row->warehouses_id);
            if(!isset($product_sum_quantity[$row->product_id]))
                $product_sum_quantity[$row->product_id] = array('quantity' => $row->quantity,'price' => $row->price);
            else
                $product_sum_quantity[$row->product_id]['quantity'] += $row->quantity;
            
            if(count($warehouse) > 0)
                $this->warehouses_detail->update(array('quantity' => ((int)$warehouse->quantity + (int)$row->quantity)),array('id' => $warehouse->id));
            else
                $this->warehouses_detail->insert(array('product_id' => $row->product_id,'warehouses_id' => $row->warehouses_id,'quantity' => $row->quantity));
        }
        
        foreach ($product_sum_quantity as $key => $row){
            $detail = $this->bill_detail->getDetailbyProductAndBill($bill_detail[0]->bill_id,$key);
            if(count($detail) > 0)
                $this->bill_detail->update(array('quantity' => $row['quantity'],'price' => $row['price']),array('id' => $detail->id));
        }
        
        #return retail warehouse
        $retail = $data->retail;
        foreach($retail as $key => $row){
            $retail_product = $this->warehouse_retail->get_by_product_id($row->product_id);
            $detail = $this->bill_detail->getDetailbyProductAndBill($bill_detail[0]->bill_id,$row->product_id);
            if(count($detail) > 0)
                $this->bill_detail->update(array('quantity' => $row->quantity,'price' => $row->price),array('id' => $detail->id));
            
            if(count($retail_product) > 0)
                $this->warehouse_retail->update(array('quantity' => ((int)$retail_product->quantity + (int)$row->quantity)),array('product_id' => $row->product_id));
            else
                $this->warehouse_retail->insert(array('product_id' => $row->product_id,'quantity' => $row->quantity));
        }
        
        $orders = $this->order->get_array(array('id' => $order_id));
        
        $this->order->update(array('delivery' => '1','status' => '6'),array('id' => $order_id));
        $shipment = $this->order->get_array(array('shipment_id' => $orders[0]->shipment_id,'delivery' => '0'));
        if(count($shipment) == 0){
            $this->load->model('shipments_model');
            $this->shipments_model->update(array('status' => '3'),array('id' => $orders[0]->shipment_id));
        }
        echo json_encode($product);
    }
    function convertBillCode($bill_id,$type = null){
        $bill_code = '';
        for($i = 0; $i < (7 - strlen($bill_id));$i++){
            $bill_code .= '0';
        }
        $bill_code = $type.$bill_code.$bill_id;
        return $bill_code;
    }
}
?>