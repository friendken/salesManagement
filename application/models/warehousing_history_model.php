<?php

class Warehousing_history_model extends MY_model {

    protected $table_name = 'warehousing_history';
    
    public function get_all(){
        return $this->db->query('select *,
                                (select `name` from products where id = wh.product_id) as product_name, 
                                (select `name` from warehouses where id = wh.warehouses_id) as warehouse_name 
                                from warehousing_history as wh')
                        ->result();
    }
}