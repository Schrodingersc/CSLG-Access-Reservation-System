<%@page import="cn.cslg.CSLGAccessReservationSystem.ServerBean.Manager"%>
<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>设备管理</title>
    <link rel="stylesheet" href="./css/bootstrap.min.css">
    <link rel="shortcut icon" href="door-icons.ico" type="image/x-icon"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        .container-fluid{margin: 0;padding: 0;}
        @media screen and (min-width: 768px){
            html,body,.container-fluid{width: 100%;height: 100%;}
        }
        .top_left{background: #d5a380;height: 100%}
        .top_right{background: #a27150;height: 100%;}
        .top_left h1{line-height: 5.1;text-align: right;padding: 0 15%;margin: 0;}
        .top_left a{padding: 10px 30px;float: right;border-color: #fff;background: transparent;margin-right: 20%;}
        .top_right>p{padding-right: 10%;color: #fff;line-height: 2.3}
        .top_right>p a{color:#fff;margin-left: 10px;}
        .top_right h3{color: #fff;line-height: 2}
        .top_right span{position: relative;top: 2px;}
        .top_right input{color: #fff;background: transparent;border: 1px solid #000;outline: none;height: 100%;}
        .header > div:not(:first-child){padding: 5% 0;margin-top: 1%;}
        @media screen and (max-width: 1200px){
            .san{left: 25%!important;}
        }
    </style>
</head>
 <% 
       request.setCharacterEncoding("utf-8");
       
       Manager manager = (Manager) request.getSession().getAttribute("manager");
    %>
<body>
<div class="container-fluid">
    <div class="col-lg-4 col-md-3  top_left ">
        <h1>设备管理</h1>
        <a href="./content_6.jsp" class="btn-default btn" style="background: #fff;z-index: 999">返回</a>
    </div>
    <div class="san" style="z-index: 9999;position: absolute;left: 33.3%;top: 5%;width: 0;height: 0;border-top: 25px solid transparent;border-left: 30px solid #d5a380;border-bottom: 25px solid transparent;"></div>
    <div class="col-lg-8 col-md-9  top_right clearfix">
        <p class="text-right"><span><%=manager.getUsername()%></span>  <a href="/loginOut.do" method="post"> [退出] </a></p>
        <div class="col-sm-6">
            <h3>添加新的活动室</h3>
            <h3 class="clearfix"><span class="col-sm-6">活动室名称</span>
                <input id="activityRoomName"style="margin-top: 2.5%" class="col-xs-6" type="text"></h3>
            <h3 class="clearfix"><span class="col-sm-6">活动室位置</span>
                <input id="activityRoomLocation"style="margin-top: 2.5%" class="col-xs-6" type="text">
            </h3>
        </div>
        <div class="col-sm-6">
            <h3>&nbsp;</h3>
            <div class="clearfix col-xs-12" style="margin-bottom: 10%;">
                <span class="col-sm-6 col-xs-12" style="line-height: 3;font-size: 24px;color: #fff">头像</span>
                <img class="col-sm-4 col-xs-12" src="./img/content1.png" alt="">
            </div>
        </div>
        <h3 style="line-height: 5;text-align: center">
            <a href="javascript:;" id="addActivityRoom" class="btn btn-default">保存添加</a>
        </h3>
    </div>
</div>
</body>
<script src="http://image.meilele.com/js/mll/jq.js?0419"></script>
<script type="text/javascript">
    var activityRoomName,activityRoomLocation;
    $('#addActivityRoom').click(function(){
        activityRoomName=$('#activityRoomName').val();
        activityRoomLocation=$('#activityRoomLocation').val();
         if( activityRoomName== '' ){
		alert('活动室名称不能为空！');
		return false;
	}
        if( activityRoomLocation == '' ){
		alert('活动室位置不能为空！');
		return false;
	}
        addActivityRoom();
    });
    
    
    var time=3;
function addActivityRoom(){
      var xmlhttp;
     if (window.XMLHttpRequest) {
         xmlhttp=new XMLHttpRequest();
     } else {          
         xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
     }
     

     xmlhttp.open("GET","AddActivityRoomServlet?room_name="+activityRoomName+"&information="+activityRoomLocation,true);
     xmlhttp.send();
     xmlhttp.onreadystatechange=function() {
         if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
             var x=xmlhttp.responseText;
             alert(x);
             if(x=="true"){
                 alert("添加新的活动室成功，3秒后跳转到首页！");
                 setInterval(go, 1000);  
             }else{
                 alert("添加活动室失败！");
                 location.href='content6_addactivityroom.jsp';
             }
         }
     }
}

function go(){ 
    time--; 
    if(time>0){ 
        document.getElementById("addActivityRoom").innerHTML=time;
    }else{ 
        location.href='content_6.jsp';
    }
} 
</script>
</html>