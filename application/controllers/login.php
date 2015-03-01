<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Login extends CI_Controller {

    /**
     * Index Page for this controller.
     *
     * Maps to the following URL
     * 		http://example.com/index.php/welcome
     * 	- or -  
     * 		http://example.com/index.php/welcome/index
     * 	- or -
     * Since this controller is set as the default controller in 
     * config/routes.php, it's displayed at http://example.com/
     *
     * So any other public methods not prefixed with an underscore will
     * map to /index.php/welcome/<method_name>
     * @see http://codeigniter.com/user_guide/general/urls.html
     */
    public function index() {
        $this->load->helper('html');
        $this->load->helper('url');
        
        $this->load->view('login', array('data' => 'H?o ??p trai'));
    }
    public function check_login(){
        $user = $_POST;
        $this->load->model('user_model','user');
        
        $login = $this->user->get_login($user['username'],$user['password']);
        if(count($login) > 0){
            $this->session->set_userdata(array('user_id' => $login->id));
            echo json_encode(array('status' => 'success'));die;
        }
        
        echo json_encode(array('status' => 'error'));
    }
    public function logout(){
        $this->session->unset_userdata('user_id');
        $this->load->helper('url');
        redirect('login');
    }

}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */