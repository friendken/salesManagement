<?php

class Customers_model extends MY_model {
    
    protected $table_name = 'customers';
    
    public function get_all_customer_by_type($type){
        $customers =  $this->db->where('type', $type)
                                ->where('active','0')
                                ->get($this->table_name)
                                ->result();
        foreach($customers as $key => $row){
            $customers[$key]->phone_home = json_decode($row->phone_home,true);
            $customers[$key]->phone_mobile = json_decode($row->phone_mobile,true);
        }

        return $customers;
    }
    public function get_array($where_arr = null){
        $customers = parent::get_array($where_arr);
        foreach($customers as $key => $row){
            $customers[$key]->phone_mobile = json_decode($row->phone_mobile,true);
            $customers[$key]->phone_home = json_decode($row->phone_home,true);
        }
        return $customers;
    }
}
?>