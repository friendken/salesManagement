<?php
if (!defined('BASEPATH'))
    exit('No direct script access allowed');

class User extends CI_Controller{
    
    public function __construct() {
        parent::__construct();
        $this->load->model('user_model','user');
        $this->load->model('role_model','role');
    }
    public function index(){
        $users = $this->user->get_array(array('active' => '0'));
        $roles = $this->role->get_all();
        echo json_encode(array('roles' => $roles,'users' => $users));
    }
    public function createUser(){
        $user = $this->input->json();
        $user_id = $this->user->insert($user);
        echo json_encode($user_id);
    }
    public function getUser(){
        $user_id = $this->input->get('id');
        $user = $this->user->get_by_id($user_id);
        echo json_encode(array('user' => $user));
    }
    public function editUser(){
        $user_id = $this->input->get('id');
        $user = $this->input->json();
        $this->user->update($user,array('id' => $user_id));
    }
    public function deleteUser(){
        $user_id = $this->input->get('id');
        $this->user->update(array('active' => '1'),array('id' => $user_id));
    }
}

