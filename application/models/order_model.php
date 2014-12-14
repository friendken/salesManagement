<?php

class Order_model extends MY_model {
    protected $table_name = 'order';
    
    public function get_all(){
        return $this->db->query('select *,
                                (select `name` from customers where id = o.customer_id) as customer_name,
                                (select `address` from customers where id = o.customer_id) as customer_address
                                from `'.$this->table_name.'` as o
                                where shipment_id is NULL')
                        ->result();
    }
}
