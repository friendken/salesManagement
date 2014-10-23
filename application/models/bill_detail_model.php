<?php

class Bill_detail_model extends MY_model {
    protected $CI;
    protected $table_name = 'bill_detail';
   
    public function get_by_bill_id($bill_id){
        return $this->db->query('select *,(select `name` from products where id = b.product_id) as product_name from bill_detail as b where bill_id = '.$bill_id)
                        ->result();
    }
}