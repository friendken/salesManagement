<?php

class Warehousing_model extends MY_model {
    protected $CI;
    protected $table_name = 'warehousing';
    
    public function getDebit(){
        return $this->db->where('debit != null or debit != 0')
                        ->get($this->table_name)
                        ->result();
    }
}

