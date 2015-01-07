<?php

class Warehousing_model extends MY_model {
    protected $CI;
    protected $table_name = 'warehousing';
    
    public function __construct() {
        parent::__construct();
        $this->ci = $ci = get_instance();
        $ci->load->model('products_buy_price_model','product_buy');
    }
    public function getDebit(){
        return $this->db->where('debit != null or debit != 0')
                        ->get($this->table_name)
                        ->result();
    }
    public function get_by_id($id) {
        $row = parent::get_by_id($id);
        $row->detail = $this->ci->product_buy->get_by_warehousing_id($id);
        return $row;
    }
}

