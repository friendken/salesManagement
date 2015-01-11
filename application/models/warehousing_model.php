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
        return $this->db->select('w.*,
                        (select name from customers where id = w.partner_id) as partner_name')
                        ->where('debit != null or debit != 0')
                        ->from($this->table_name.' as w')
                        ->get()
                        ->result();
    }
    public function get_by_id($id) {
        $row = parent::get_by_id($id);
        $row->detail = $this->ci->product_buy->get_by_warehousing_id($id);
        return $row;
    }
}

