<?php

class User_model extends MY_model{
    protected $table_name = 'users';
    
    public function get_array($where_arr = null) {
        return $this->db->select('*,(select name from roles where id = users.role) as role_name')
                        ->where('active','0')
                        ->get($this->table_name)
                        ->result();
                        
    }
    public function get_login($user_name, $password){
        return $this->db->like('user_name',$user_name)
                        ->like('password',$password)
                        ->where('active','0')
                        ->get($this->table_name)
                        ->row();
    }
    
}