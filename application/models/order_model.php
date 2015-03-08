<?php

class Order_model extends MY_model {
    protected $table_name = 'order';
    
    public function get_all(){
        return $this->db->query('select *,
                                (select `name` from customers where id = o.customer_id) as customer_name,
                                (select `address` from customers where id = o.customer_id) as customer_address
                                from `'.$this->table_name.'` as o
                                where o.shipment_id is NULL
                                and o.delivery = "0"')
                        ->result();
    }
    public function get_array($where_arr = null,$customer = null) {
        if(!isset($customer))
            $orders = parent::get_array($where_arr);
        else{
            $orders = parent::get_array($where_arr);
            $this->load->model('customers_model','customers');
            $this->load->model('order_status_type_model','order_status');
            foreach ($orders as $key => $row){
                $orders[$key]->customer_detail = $this->customers->get_by_id($row->customer_id);
                $orders[$key]->status = $this->order_status->get_by_id($row->status);
            }
        }
        return $orders;
    }
    public function get_by_id($id) {
        $order = parent::get_by_id($id);
        $this->load->model('order_detail_model','order_detail');
        $order->order_detail = $this->order_detail->get_array(array('order_id' => $id));
        return $order;
    }
    public function getRestOrder($truck_id){
        return $this->db->query('select *,
                                (select `name` from customers where id = o.customer_id) as customer_name,
                                (select address from customers where id = o.customer_id) as customer_address
                                from `'.$this->table_name.'` as o
                                where shipment_id in (select id from shipments where truck_id = '.$truck_id.' and `status` != 3)')
                        ->result();
    }
}
