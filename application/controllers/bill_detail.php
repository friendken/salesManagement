<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Bill_detail extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('bill_model','bill');
    }
    public function index() {
        $id = $_GET['id'];
        $bill_detail = $this->bill->get_by_id($id);
        echo json_encode(array('bill' => $bill_detail));
    }

}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */