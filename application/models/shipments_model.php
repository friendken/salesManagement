<?php

Class Shipments_model extends MY_model{
    protected $table_name = 'shipments';
    
    public function __construct() {
        parent::__construct();
        $this->load->model('order_model','order');
        $this->load->model('trucks_model','trucks');
        $this->load->model('customers_model','customers');
        $this->load->model('staff_model','staff');
    }
    public function get_all() {
        $shipments = parent::get_all();
        foreach($shipments as $key => $row){
            $shipments[$key]->orders = $this->order->get_array(array('delivery' => '0','shipment_id' => $row->id),true);
        }
        return $shipments;
    }
    public function get_array($where_arr = null) {
        $shipments = parent::get_array($where_arr);
        foreach($shipments as $key => $row){
            $shipments[$key]->orders = $this->order->get_array(array('delivery' => '0','shipment_id' => $row->id),true);
            $shipments[$key]->driver_detail = $this->staff->get_by_id($row->driver);
            $shipments[$key]->sub_driver_detail = $this->staff->get_by_id($row->sub_driver);
            $shipments[$key]->truck_detail = $this->trucks->get_by_id($row->truck_id);
        }
        return $shipments;
    }
    public function get_shipment($start,$end){
        return $this->db->query("select *,
                                (select name from staffs where id = s.driver) as driver_name,
                                (select name from trucks where id = s.truck_id) as truck_name,
                                (select count(*) from `order` where shipment_id = s.id) as order_quantity
                                from shipments as s
                                where created >= '".$start." 00:00:00' AND created <= '".$end." 24:00:00' and `status` = 3")
                        ->result();
    }
    public function get_by_id($id) {
        $shipment = parent::get_by_id($id);
        $shipment->driver_detail = $this->db->where('id',$shipment->driver)->get('staffs')->row();
        $shipment->truck_detail = $this->db->where('id',$shipment->truck_id)->get('trucks')->row();
        $shipment->order_detail = $this->db->where('shipment_id',$id)->get('order')->result();
        return $shipment;
    }
}

