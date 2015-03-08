<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        
        <meta name="description" content="" />
        <meta name="keywords" content="" />

        <title>Dashboard</title>
        <link type="text/css" rel='stylesheet' href="/www/css/zice.style.css" />
        <link type="text/css" rel='stylesheet' href="/www/css/icon.css" />
        <link type="text/css" rel='stylesheet' href="/www/css/ui-custom.css" />
        <link rel="stylesheet" type="text/css" href="/www/css/dataTables.css"  />
        <link rel="stylesheet" type="text/css" href="/www/css/chosen.css"  />
        
        
        <script type="text/javascript" src="/www/js/jquery.min.js"></script>
        <script type="text/javascript" src="/www/js/jquery.cookie.js"></script>
        <script type="text/javascript" src="/www/js/jquery.ui.min.js"></script>
        <script type="text/javascript" src="/www/js/dataTables.min.js"></script>
        <script type="text/javascript" src="/www/js/ColVis.js"></script>
        <script type="text/javascript" src="/www/js/component/chosen.js"></script>
        <script type="text/javascript" src="/www/js/component/customInput.jquery.js"></script>
        <script type="text/javascript" src="/www/js/component/numeral.min.js"></script>
        
        
        
        
        <script src="/www/js/angular/angular.js"></script>
        <script src="/www/js/angular-route/angular-ui-router.js"></script>
        

        <script src="/www/js/app.js"></script>
        <script src="/www/js/services.js"></script>
        <script src="/www/js/controllers.js"></script>
        <script src="/www/js/filters.js"></script>
        <script src="/www/js/directives.js"></script>
        <script src="/www/js/angular/ui-bootstrap.min.js"></script>
        <script src="/www/js/sale_manager.js"></script>
        
        
        <script>
            var config = {base: "<?php echo site_url()?>"};
        </script>
    </head> 

    <body class="dashborad">
        <div id="overlay"></div>
        <div id="alertMessage" class="error"></div> 

        <div id="header" >
            <div id="account_info"> 

                <div class="setting" title="Thông tin tài khoản">
                    <b>Chào, </b> 
                    <b class="red">&nbsp; <?php echo $user->user_name ?></b>
<!--                    <a href='/SaleManagement/managers/personal_information'>
                        <img src="/www/img/gear.png" class="gear"  alt="Thông tin tài khoản" />
                    </a>-->
                </div>
                <div class="logout" title="Đăng xuất">
                    <b >Đăng xuất</b>
                    <a href='<?php echo site_url() ?>/login/logout'> 
                        <img src="/www/img/connect.png" name="connect" class="disconnect" alt="Đăng xuất" ></a>
                </div> 
            </div>
        </div> <!--//  header -->
        <div id="shadowhead" style="display: block; position: absolute;"></div>                         
        <div id="left_menu">
                 <?php 
                         include 'include/left_menu.html';
                 ?>   
        </div>


        <div id="content" ng-app="dashboard">
            <div class="inner">
                <div class="topcolumn">
                    <div class="logo"></div>
                </div>
                <div class="clear"></div>

                   <div ui-view="content">

                    </div>

                <div class="clear"></div>
                <div id="footer"> &copy; Copyright 2014 <span class="tip"><a  href="#" title="Zice Admin" >friendken</a> </span> </div>
            </div> <!--// End inner -->
        </div> <!--// End content --> 
    </body>
</html>


