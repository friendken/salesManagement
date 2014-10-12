<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Products extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('products_model','product');
        $this->load->model('products_sale_price_model','product_sale');
    }
    public function index() {
        $this->load->model('products_type_model','product_type');
        $product = $this->product->get_all();
        
        foreach($product as $key => $row){
            //get product type
            $product_type = $this->product_type->get_by_id($row->product_type);
            $product[$key]->product_type = $product_type->name;
            //cut create date
            $date = explode(' ',$row->created);
            $product[$key]->created = $date[0];
        }
        
        echo json_encode($product);
    }
    public function createProductView(){
        if(isset($_GET['id'])){
            $product = $this->product->get_by_id($_GET['id']);
//            var_dump($product);die;
        }
            
        $this->load->model('products_type_model','product_type');
        $product_type = $this->product_type->get_all();
        if(isset($product))
            echo json_encode (array('products' => $product,'product_type' => $product_type));
        else
            echo json_encode(array('product_type' => $product_type));
    }
    public function createProduct(){
        $product = $this->input->json();
        $list_price = $product->list_price;
        unset($product->list_price);
        $product_id = $this->product->insert($product);
        $sale_id = null;
        foreach($list_price as $key => $value){
            $sale_detail = array();
            foreach ($value as $item => $row){
                foreach ($row as $sale_key => $sale_value){
                    $sale_detail[$sale_key] = $sale_value;
                }
            }
            $sale_detail['product_id'] = $product_id;
            $sale_detail['parent_id'] = $sale_id;
            $sale_id = $this->product_sale->insert($sale_detail);
            
        }
//        echo json_encode($list_price);
    }
    public function editProduct(){
        $id = $_GET['id'];
        $product = $this->input->json();

        $list_price = $product->list_price;
        unset($product->list_price);
        $product_id = $this->product->update($product,array('id' => $id));
        $this->product_sale->delete(array('product_id' => $id));
        $sale_id = null;
        
        foreach($list_price as $key => $value){
            $sale_detail = array();
            foreach ($value as $item => $row){
                foreach ($row as $sale_key => $sale_value){
                    $sale_detail[$sale_key] = $sale_value;
                }
            }
            $sale_detail['product_id'] = $product_id;
            $sale_detail['parent_id'] = $sale_id;
            $sale_id = $this->product_sale->insert($sale_detail);
        }
    }
}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */