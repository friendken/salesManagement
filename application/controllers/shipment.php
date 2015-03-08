<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Shipment extends CI_Controller {
    
    public function __construct() {
        parent::__construct();
        $this->load->model('shipments_model','shipments');
        $this->load->model('order_model','order');
    }
    public function index(){
        $from = $this->input->get('from');
        $to = $this->input->get('to');
        $shipments = $this->shipments->get_shipment($from,$to);
        echo json_encode(array('shipments' => $shipments));
    }
    public function shipmentDetail(){
        $id = $this->input->get('id');
        $shipment = $this->shipments->get_by_id($id);
        $this->load->model('cutomers_model','customers');
        foreach ($shipment->order_detail as $key => $row){
            $shipment->order_detail[$key]->customer_detail = $this->customers->get_by_id($row->customer_id);
        }
        echo json_encode(array('shipment' => $shipment));
    }
}