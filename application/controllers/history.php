<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class History extends CI_Controller {

    public function warehousingHistory() {
        $this->load->model('warehousing_history_model','history');
        $history = $this->history->get_all();
        $i = 1;
        foreach ($history as $row => $key){
            $history[$row]->stt = $i;
            $i++;
        }
        echo json_encode(array('history' => $history));
    }
    
}
?>
