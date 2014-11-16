<?php

class Bill_model extends MY_model {
    protected $CI;
    protected $table_name = 'bill';
    
    public function __construct() {
        parent::__construct();
        $this->ci = $ci = get_instance();
        $ci->load->model('bill_detail_model','bill_detail');
        
    }


    public function get_all_by_type($type){
        $bills = $this->db->where('warehouse', $type)
                        ->order_by('created','decs')
                        ->get($this->table_name)
                        ->result();
        if(count($bills) > 0){
            foreach($bills as $key => $row){
                $date = explode(' ', $row->created);
                $bills[$key]->created = $date[0];  
            }
            return $bills;
        }else
            return $bills;
    }
    
    public function get_by_id($id) {
        $bill = parent::get_by_id($id);
        $bill->detail = $this->ci->bill_detail->get_by_bill_id($id);
        $i = 1;
        foreach ($bill->detail as $key => $row){
            $bill->detail[$key]->stt = $i;
            $i++;
        }
        return $bill;
    }
    public function getDebit(){
        return $this->db->where('debit != null or debit != 0')
                        ->get($this->table_name)
                        ->result();
    }
}