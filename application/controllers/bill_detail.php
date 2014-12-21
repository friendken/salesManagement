<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Bill_detail extends CI_Controller {

    public function __construct() {
        parent::__construct();
        $this->load->model('bill_model','bill');
        $this->load->model('products_sale_price_model','product_sale');
    }
    public function index() {
        $id = $_GET['id'];
        $type = $_GET['type'];
        $this->load->model('customers_model','customer');
        $bill_detail = $this->bill->get_by_id($id);
        $bill_detail->customer = $this->customer->get_by_id($bill_detail->customer_id);
        foreach ($bill_detail->detail as $key => $row){
            if($type == 'wholesale')
                $bill_detail->detail[$key]->unit = $this->product_sale->get_unit_primary($row->product_id);
            else
                $bill_detail->detail[$key]->unit = $this->product_sale->get_unit_retail($row->product_id);
        }
        echo json_encode(array('bill' => $bill_detail));
    }

}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */