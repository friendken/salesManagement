<?php

class Warehouse_wholesale_model extends MY_model {
    protected $CI;
    protected $table_name = 'warehouse_wholesale';
    
    public function get_by_product_id($product_id){
        return $this->db->where('product_id', $product_id)
                        ->get($this->table_name)
                        ->row();
    }
    public function get_all() {
        return $this->db->query('select *,
                                (select `name` from products where id = ww.product_id) as `name`,
                                (select code from products where id = ww.product_id) as code,
                                (select `name` from products_sale_price where ww.unit = id) as unit_name
                                from warehouse_wholesale as ww')
                        ->result();
    }
}

