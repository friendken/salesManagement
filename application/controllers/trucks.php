<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Trucks extends CI_Controller {

    public function __construct(){
        parent::__construct();
        $this->load->model('trucks_model','trucks');
    }
    public function index(){
        $trucks = $this->trucks->get_array(array('active' => 0));
        echo json_encode(array('trucks' => $trucks));
    }
    public function createTruck(){
        $truck = $this->input->json();
        return $this->trucks->insert($truck);
    }
    public function getTruck(){
        $truck_id = $this->input->get('id');
        $truck = $this->trucks->get_by_id($truck_id);
        echo json_encode(array('truck' => $truck));
    }
    public function editTruck(){
        $truck_id = $this->input->get('id');
        $truck = $this->input->json();
        $this->trucks->update($truck, array('id' => $truck_id));
    }
    public function deleteTruck(){
        $truck_id = $this->input->get('id');
        $this->trucks->update(array('active' => 1),array('id' => $truck_id));
    }
}