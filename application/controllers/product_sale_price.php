<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Product_sale_price extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('products_sale_price_model','sale_price');
        $this->load->model('products_model','products');
    }
    public function index() {
        $code_product = $_GET['product_id'];
        $type = $_GET['type'];
        $product = $this->products->get_by_code($code_product);
        $product_id = $product->id;

        $storge = $storge_in_house = 0;
        $sale_price = $this->sale_price->get_by_product_id($product_id);

        if($type == 'wholesale'){
            #get count in warehouses
            $this->load->model('warehouses_detail_model','warehouses_detail');
            $warehouses = $this->warehouses_detail->count_product_all_warehouses($product_id);

            #get count in wholesale warehouse
            $this->load->model('warehouse_wholesale_model','warehouse_wholesale');
            $whole = $this->warehouse_wholesale->get_by_id($product_id);
            if(count($whole) > 0){
                $storge = (int)$warehouses->total + (int)$whole->quantity;
                $storge_in_house = (int)$whole->quantity;    
            }
            
        }else{
            $this->load->model('warehouse_retail_model','warehouse_retail');
            $retail = $this->warehouse_retail->get_by_product_id($product_id);
            if(count($retail) > 0){
                $storge = (int)$retail->quantity;
                $storge_in_house = (int)$retail->quantity;    
            }
        }
        
        echo json_encode(array('unit' => $sale_price,'storge' => $storge,'storge_in_house' => $storge_in_house));
    }
    
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */