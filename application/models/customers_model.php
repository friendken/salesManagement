<?php

class Customers_model extends MY_model {
    
    protected $table_name = 'customers';
    
    public function get_all_customer_by_type($type){
        return $this->db->where('type', $type)
                        ->where('active','0')
                        ->get($this->table_name)
                        ->result();
    }
    
}
?>