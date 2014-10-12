<?php

class Warehouse_wholesale_model extends MY_model {
    protected $CI;
    protected $table_name = 'warehouse_wholesale';
    
    public function get_by_product_id($product_id){
        return $this->db->where('product_id', $product_id)
                        ->get($this->table_name)
                        ->row();
    }
    
}

