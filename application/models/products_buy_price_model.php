<?php

class Products_buy_price_model extends MY_model {
    protected $CI;
    protected $table_name = 'products_buy_price';
    
    public function get_by_product_id($product_id){
        return $this->db->where('product_id', $product_id)
                        ->get($this->table_name)
                        ->result();
    }
    public function get_old_product($product_id, $warehouse_type){
        return $this->db->where('product_id',$product_id)
                        ->where('warehouse', $warehouse_type)
                        ->where('remaining_quantity')
                        ->order_by('created')
                        ->get($this->table_name)
                        ->row();
    }
}

