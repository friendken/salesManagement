<?php

class Export_bill_model extends MY_model {
    protected $table_name = 'export_bill';
    
    public function get_all() {
        return $this->db->query('select * ,
                                (select `name` from warehouses where id = eb.warehouse_from) as warehouse_name_from,
                                (select `name` from warehouses where id = eb.warehouse_to) as warehouse_name_to
                                from '.$this->table_name.' as eb')
                        ->result();
    }
    public function get_by_id($id) {
        $row = parent::get_by_id($id);
        $row->warehouse_name_from = $this->db->query('select `name` from warehouses where id = '.$row->warehouse_from)->row('name');
        $row->warehouse_name_to = $this->db->query('select `name` from warehouses where id = '.$row->warehouse_to)->row('name');
        $row->detail = $this->db->query('select *, 
                            (select `name` from products where id = ed.product_id) as product_name,
                            (select `name` from products_sale_price where product_id = ed.product_id and parent_id is null)as unit_name
                            from export_detail as ed where export_id = '.$id)
                                ->result();
        return $row;
    }
}
?>