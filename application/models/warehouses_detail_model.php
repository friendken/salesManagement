<?php

class Warehouses_detail_model extends MY_model {

    protected $table_name = 'warehouses_detail';
    
    public function get_product_storge($product_id,$warehouses_id){
        return $this->db->where('product_id', $product_id)
                        ->where('warehouses_id', $warehouses_id)
                        ->get($this->table_name)
                        ->row();
    }
    public function get_warehouse_storge($warehouses_id){
        return $this->db->select('*,(select name from products where id = warehouses_detail.product_id) as product_name')
                        ->where('warehouses_id', $warehouses_id)
                        ->get($this->table_name)
                        ->result();
    }
    public function get_product_out_of_storge(){
        return $this->db->query('select *, 
                                (select `name` from products where id = wd.product_id) as product_name,
                                (select `name` from warehouses where id = wd.product_id) as warehouse_name,
                                (select `name` from products_type where id =(select product_type from products where id = wd.product_id)) as product_type_name
                                from warehouses_detail as wd
                                where quantity <= 5')
                        ->result();
    }
    public function count_product_all_warehouses($product_id){
        return $this->db->query('select SUM(quantity) as total from warehouses_detail
                                where product_id = '.$product_id)
                        ->row();
    }
    public function get_warehouse_status(){
        return $this->db->query('select *,
                                (select `name` from warehouses where id = wd.warehouses_id) as warehouses_name,
                                (select `name` from products where wd.product_id = id) as product_name,
                                (select `name` from products_sale_price where product_id = wd.product_id and parent_id is null) as unit_name
                                from warehouses_detail as wd
                                order by product_id')
                        ->result();
    }
}