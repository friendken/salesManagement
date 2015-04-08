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
    public function get_out_stock(){
        return $this->db->query('select *,quantity as total_quantity,
                                (select name from products where id = ww.product_id) as product_name,
                                (select name from products_type where id in (select product_type from products as p where p.id = ww.product_id)) as product_type_name
                                from warehouse_wholesale as ww
                                where quantity < 5')
                        ->result();
    }
    public function get_all_for_warehouses() {
        return $this->db->query('select *,
                                0 as warehouses_id,
                                ("Kho nhà") as warehouses_name,
                                (select `name` from products where id = ww.product_id) as `product_name`,
                                (select `name` from products_sale_price where ww.unit = id) as unit_name
                                from warehouse_wholesale as ww
                                where ww.quantity > 0')
                        ->result();
    }
}

