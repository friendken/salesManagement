<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Debit extends CI_Controller {

    public function totalLiability() {
        $this->load->model('warehousing_model');
        $warehousing = $this->warehousing_model->getDebit();
        $i = 1;
        foreach ($warehousing as $row => $key){
            $warehousing[$row]->stt = $i;
            $i++;
        }
        echo json_encode(array('bill' => $warehousing));
    }
    public function totalDebit() {
        $this->load->model('bill_model');
        $bill = $this->bill_model->getDebit();
        $i = 1;
        foreach ($bill as $row => $key){
            $bill[$row]->stt = $i;
            $i++;
        }
        echo json_encode(array('bill' => $bill));
    }
}

