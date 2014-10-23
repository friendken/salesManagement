<?php

class Products_sale_price_model extends MY_model {
    protected $CI;
    protected $table_name = 'products_sale_price';
    
    public function get_by_product_id($product_id){
        return $this->db->where('product_id', $product_id)
                        ->get($this->table_name)
                        ->result();
    }
    public function get_unit_primary($product_id){
        return $this->db->where('product_id',$product_id)
                        ->where('parent_id',null)
                        ->get($this->table_name)
                        ->row();
    }
    public function get_unit_retail($product_id){
        return $this->db->where('product_id', $product_id)
                        ->order_by('id','desc')
                        ->limit(1)
                        ->get($this->table_name)
                        ->row();
    }
}

