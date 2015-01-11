<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Debit extends CI_Controller {

    public function totalLiability() {
        $this->load->model('warehousing_model');
        $warehousing = $this->warehousing_model->getDebit();
        echo json_encode(array('bill' => $warehousing));
    }
    public function totalDebit() {
        $this->load->model('bill_model');
        $bill = $this->bill_model->getDebit();
        echo json_encode(array('bill' => $bill));
    }
    public function warehousingDetail(){
        $warehousing_id = $this->input->get('id');
        $this->load->model('warehousing_model');
        $this->load->model('customers_model','customers');
        $warehousing = $this->warehousing_model->get_by_id($warehousing_id);
        $warehousing->partner_detail = $this->customers->get_by_id($warehousing->partner_id);
        echo json_encode(array('bill' => $warehousing));
    }
}

