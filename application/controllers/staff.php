<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Staff extends CI_Controller {

    public function __construct(){
        parent::__construct();
        $this->load->model('staff_model','staff');
        //Lấy đường dẫn vật lý của thư mục chứa hình ảnh đươc upload
        $this->_gallery_path = realpath(APPPATH . "../www/img/avatar_staff");
    }
    public function index(){
        $staffs = $this->staff->get_array(array('active' => 0));
        echo json_encode(array('staffs' => $staffs));
    }
    public function detailStaff(){
        $staff_id = $this->input->get('id');
        $staff = $this->staff->get_by_id($staff_id);
        echo json_encode(array('staff' => $staff));
    }
    public function getPosition(){
        $this->load->model('position_model');
        $position = $this->position_model->get_all();
        echo json_encode(array('position' => $position));
    }
    public function uploadAvatar(){
//        $file = $_FILES;
        $config = array('upload_path' => $this->_gallery_path,
            'allowed_types' => 'gif|jpg|png',
            'max_size' => '20000000',
            'encrypt_name' => TRUE);
        // 'file_name' => 'avatar_account_'.$this->session->userdata('account_id').'_user_' . $user_id,
        // 'overwrite' => TRUE);

        $this->load->library('upload', $config);
        if (!$this->upload->do_upload('file')) {
            $status = 'error';
            echo $msg = $this->upload->display_errors('', '');
        } else {
            $data = $this->upload->data();
            echo $data['file_name'];
        }
    }
    public function createStaff(){
        $staff = $this->input->json();
        $staff_id = $this->staff->insert($staff);
        echo json_encode($staff_id);
    }
    public function editStaff(){
        $staff_id = $this->input->get('id');
        $staff = $this->input->json();
        $this->staff->update($staff,array('id' => $staff_id));
    }
}