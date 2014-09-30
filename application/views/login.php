<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <title>Login Site</title>
        <link type="text/css" rel='stylesheet' href="/www/css/zice.style.css" />
        <link type="text/css" rel='stylesheet' href="/www/css/icon.css" />
        <link type="text/css" rel='stylesheet' href="/www/css/tipsy.css"/>
        <link type="text/css" rel='stylesheet' href="/www/css/style.css" />
    </head>
    <body >

        <div id="alertMessage" class="error"></div>
        <div id="successLogin"></div>
        <div class="text_success"><img src="/www/img/loadder/loader_green.gif"  alt="ziceAdmin" /><span>Please wait</span></div>

        <div  >
            <div class="ribbon"></div>
            <div class="inner">
                <div  class="logo" ><img src="/www/img/logo/logo_login.png" alt="ziceAdmin" /></div>
                <div class="userbox"></div>
                <div class="formLogin">
                    <?php echo $data ?>
                    <form name="formLogin"  id="formLogin" action="login" method="post">
                        <div class="tip">
                            <input name="data[User][username]" type="text"  id="username_id"  title="Tên đăng nhập"   />
                        </div>
                        <div class="tip">
                            <input name="data[User][password]" type="password" id="password"   title="Mật khẩu"  />
                        </div>

                        <div style="padding:20px 0px 0px 0px ;">

                            <div style="float:right;padding:2px 0px ;">
                                <div> 
                                    <ul class="uibutton-group">
                                        <li><a class="uibutton normal" href="#"  id="but_login" >Đăng nhập</a></li>
                                    </ul>
                                </div>
                            </div>

                        </div>

                    </form>
                </div>
            </div>
            <div class="clear"></div>
            <div class="shadow"></div>
        </div>

        <!--Login div-->
        <div class="clear"></div>
        <div id="versionBar" >
            <div class="copyright" > &copy; Copyright 2013  All Rights Reserved <span class="tip"><a  href="#" title="" >H team</a> </span> </div>
            <!-- // copyright-->
        </div>
        <!-- Link JScript-->
    </body>
</html>


