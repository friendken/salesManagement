function calculatorMoney(el) {
    var id = $(el).closest('tr').data('id');
    var target = $(el).closest('tr');
    var quantity = target.children('td:nth-child(4)').children().val().trim();
    var price = target.children('td:nth-child(6)').children().val().trim();
    if (quantity == '' || isNaN(quantity))
        return false;
    if (price == '' || isNaN(price))
        return false;

    var bill = parseInt(quantity) * parseInt(price);
    $('#show_bill_product_' + id).html('<h4>' + numeral(bill).format('0,0') + '</h4>');
    $('#txt_hide_' + id).val(bill)
    var total_bill = 0;
    $('.bill_product').each(function () {
        if (this.value != '') {
            total_bill += parseInt(this.value);
        }
    })
    $('#total_bill').text(numeral(total_bill).format('0,0'));
    $('#txt_hide_total_bill').val(total_bill);

}
function loadUnitProduct(el,sale) {
    var id = $(el).closest('tr').data('id');
    var target = $(el).closest('tr');
    var product_id = target.children('td:nth-child(3)').children().val();
    $.ajax({
        type: 'POST',
        dataType: 'json',
        url: config.base + '/product_sale_price?product_id=' + product_id,
        success: function (respone) {
            var html_select = '';
            for (var x in respone) {
                html_select += '<option value="' + respone[x].id + '">' + respone[x].name + '</option>'
            }
            if(sale)
                target.children('td:nth-child(6)').children().val(respone[0].price);
            $('#tr_product_buy_price_' + id + ' td.load_unit').html('<select onchange="selectPrice(this,true)" data-placeholder="chọn quy cách" class="chzn-select">' + html_select + '</select>');
            $(' select').not("select.chzn-select,select[multiple],select#box1Storage,select#box2Storage").selectmenu({
                style: 'dropdown',
                transferClasses: true,
                width: null
            });

            $(".chzn-select").chosen();
        }
    })
}
function selectPrice(el,sale){
    $.ajax({
        type: "GET",
        dataType: 'json',
        url: config.base + '/warehouse_wholesale_sale/getPrice?id=' + el.value,
        success: function(respone){
            if(respone && sale){
                $(el).parent().next().children().val(respone.price)
                $(el).parent().prev().children().trigger('onkeyup')
            }
        }
    })
}