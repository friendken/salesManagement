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
}
?>