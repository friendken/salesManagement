<?php

class Products_model extends MY_model {

    protected $CI;
    protected $table_name = 'products';
    
    public function __construct() {
        parent::__construct();
        $this->ci = $ci = get_instance();
        $ci->load->model('products_sale_price_model','product_sale');
        $ci->load->model('products_buy_price_model','product_buy');
        $ci->load->model('products_type_model','product_type');
    }
    public function get_by_id($id,$order = null) {
        $product = $this->db->where('id',$id)
                            ->get($this->table_name)
                            ->row();
                    
        $product->product_type = $this->ci->product_type->get_by_id($product->product_type);
        
        $product_sale = $this->ci->product_sale->get_by_product_id($product->id);
        if(count($product_sale) > 0){
            foreach($product_sale as $key => $row){
                if($row->parent_id){
                    $product_sale_row = $this->ci->product_sale->get_by_id($row->parent_id);
                    $product_sale[$key]->parent_name  = $product_sale_row->name.' =';
                }
            }
            $product->sale_price = $product_sale;
            
        }
        
        if(!$order)
            $product_buy = $this->ci->product_buy->get_by_product_id($product->id);
        else
            $product_buy = $this->ci->product_buy->get_by_product_id($product->id,$order);
        
        if(count($product_buy) > 0){
            foreach($product_buy as $key => $row){
                $buy_type = $this->ci->product_sale->get_by_id($row->unit);
                $product_buy[$key]->unit = $buy_type->name;
            }
            $product->buy_price = $product_buy;
        }
        return $product;
    }
    public function get_all_order($order = null) {
        $products = parent::get_all();
        foreach($products as $key => $row){
            $products[$key] = $this->get_by_id($row->id,$order);
        }
        return $products;
    }
}
