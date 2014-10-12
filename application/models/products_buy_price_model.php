<?php

class Products_buy_price_model extends MY_model {
    protected $CI;
    protected $table_name = 'products_buy_price';
    
    public function get_by_product_id($product_id){
        return $this->db->where('product_id', $product_id)
                        ->get($this->table_name)
                        ->result();
    }
}

