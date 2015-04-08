<?php

class Order_detail_model extends MY_model {
    protected $table_name = 'order_detail';
    
    public function get_order_detail($where_in){
        return $this->db->query('select *,
                                (select name from products where id = od.product_id) as product_name 
                                from '.$this->table_name.' as od where order_id in ('.$where_in.') ORDER BY product_id')
                        ->result();
    }
    public function delete_by_order_id($order_id){
        return $this->db->where('order_id',$order_id)
                        ->delete($this->table_name);
    }
    public function delete_by_shipment($shipment_id,$product_id){
        return $this->db->query("DELETE FROM order_detail WHERE order_id IN (SELECT id FROM `order` WHERE `shipment_id` = $shipment_id) AND product_id = $product_id");
        
    }
    public function get_by_shipment_product($shipment_id, $product_id){
        return $this->db->query("select * from order_detail where order_id in (select id from `order` where shipment_id = $shipment_id) and product_id = $product_id")
                        ->result();
    }
}