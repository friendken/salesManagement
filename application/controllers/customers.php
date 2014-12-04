<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Customers extends CI_Controller {

    public function index() {
        $type = $this->input->get('type');
        echo json_encode($type);
    }
    
}
?>
