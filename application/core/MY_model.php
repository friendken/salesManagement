<?php

class MY_model extends CI_Model {

    protected $CI;
    protected $table_name;
    protected $primary_key = 'id';

    public function __construct() {
        parent::__construct();
        $this->CI = & get_instance();
        $this->load->database();
    }
    public function get_all(){
        return $this->db->get($this->table_name)
                        ->result();
    }
    public function get_by_id($id){
        return $this->db->where('id',$id)
                        ->get($this->table_name)
                        ->row();
    }
    public function get_array($where_arr = null){
        if (isset($where_arr))
            foreach($where_arr as $index => $value)
                $this->CI->db->where("$index",$value);
        $list = $this->CI->db->get($this->table_name)->result();
        return $list;
    }
    public function insert($row_data) {
        $r = $this->db->insert($this->table_name, $row_data);
        return $this->db->insert_id();
    }

    public function update($new_data, $where) {
        return $this->db->update($this->table_name, $new_data, $where);
    }

    public function delete($where) {
        return $this->db->delete($this->table_name, $where);
    }
    
    protected function row_or_null($query) {
        $query = $this->db->get_where($this->table_name, $query);
        if ($query->num_rows() == 0) {
            return NULL;
        }
        return $query->row();
    }

    public function __set($name, $value) {
        $this->$name = $value;
    }

    public function __get($name) {
        switch ($name) {
            case 'ci':
                return $this->CI;
            case 'db':
                return $this->CI->db;
            case 'load':
                return $this->CI->load;
            default:
                if (isset($this->CI->{$name})) {
                    return $this->CI->{$name};
                }
                return $this->{$name};
        }
    }

}
