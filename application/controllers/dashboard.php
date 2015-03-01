<?php

if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class Dashboard extends CI_Controller {
    
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
        $this->required_login();
        $this->load->model('user_model','user');
        $user = $this->user->get_by_id($this->session->userdata('user_id'));
        $this->load->view('dashboard', array('user' => $user));
    }
    public function page404(){
        $this->load->view('404');
    }
    public function required_login(){
        $this->load->library('session');
        $user_id = $this->session->userdata('user_id');
        if($user_id == '')
            redirect('login');
    }

}

/* End of file welcome.php */
/* Location: ./application/controllers/welcome.php */