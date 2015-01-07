<?php

Class Shipments_model extends MY_model{
    protected $table_name = 'shipments';
    
    public function __construct() {
        parent::__construct();
        $this->load->model('order_model','order');
        $this->load->model('customers_model','customers');
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
        }
        return $shipments;
    }
}

