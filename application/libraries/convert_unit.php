<?php
class Convert_unit {
    private $ci;
    protected $unit_id;

    public function __construct() {
        $this->ci = $ci = get_instance();
        $ci->load->model('products_sale_price_model','products_sale');
    }
    public function convert_quantity($unit_id,$quantity){
        $unit_id = $unit_id?$unit_id:$this->unit_id;

        #determined unit type
        $unit = $this->ci->products_sale->get_by_id($unit_id);
        $unit_product = $this->ci->products_sale->get_by_product_id($unit->product_id);
        if($unit_id == $unit_product[(count($unit_product) - 1)]->id)
            return $quantity;

        #get position of unit in array
        foreach ($unit_product as $key => $row){
            if($row->id == $unit_id){
                $position = $key;
                break;
            }
        }
        #convert quantity of unit
        $convert_quantity = 1;
        for($i=($position + 1);$i<count($unit_product);$i++){
                $convert_quantity *= $unit_product[$i]->quantity;
        }

        return $convert_quantity*$quantity;
    }
}
?>