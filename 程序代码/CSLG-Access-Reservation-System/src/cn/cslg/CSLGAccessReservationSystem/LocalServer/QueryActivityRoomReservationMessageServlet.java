package cn.cslg.CSLGAccessReservationSystem.LocalServer;

import cn.cslg.CSLGAccessReservationSystem.ServerBean.*;



import java.util.Calendar;
import java.util.Iterator;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import java.text.NumberFormat;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by Administrator on 2017/3/20.
 */
public class QueryActivityRoomReservationMessageServlet extends HttpServlet {
    private int year;
    private int month;
    private int day;
    User user;
    Manager manager;
    Time time = null;
    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        response.setCharacterEncoding("utf-8");                                //设置 编码格式
        user = (User) request.getSession().getAttribute("user");
        manager = (Manager) request.getSession().getAttribute("manager");
        
        String flag = request.getParameter("flag");                            //标示查询预约记录

        ArrayList<ReservationMessage> reservationMessages = null;
        
        if(user != null){
             String room_id = request.getParameter("room_id");                 //获取输入的room_id
             String query_way = request.getParameter("query_way");             //查询预约记录方式
   
             if(flag.equals("query_reservationMessage")) {
                 getNewDate();
                 if(query_way.equals("查找本月预约")) {
                     time = new Time(year, month, day);
                 }else{
                    time = new Time(year, month - 1, day);
                }
                ActivityRoom activity_room = new ActivityRoom(room_id);
                reservationMessages = user.queryRoomUsage(time, activity_room);
            }
        }else{
            if(flag.equals("query_activityRoomReservation_manager")) {
                reservationMessages = manager.queryAllReservation();
            }else {
                String room_id = request.getParameter("room_id");
                ActivityRoom activity_room = new ActivityRoom(room_id);
                getNewDate();
                time = new Time(year,month,day);
                reservationMessages = manager.queryRoomUsage(time, activity_room);
            }
            
        }

        JSONArray jsonArray;
        if(reservationMessages != null) {
            jsonArray=arrayListToJSONArray(reservationMessages);
            PrintWriter pw = response.getWriter();
            pw.print(jsonArray.toString());
            pw.close();
           
        }else{
            jsonArray = new JSONArray();
            PrintWriter pw = response.getWriter();
            pw.print(jsonArray);
            pw.close();
        }  
    }




    public void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        doGet(request,response);
    }
    
    /**
     * 获取当前日期
     */
    public void getNewDate(){
         Calendar date = Calendar.getInstance();
         day = date.get(Calendar.DAY_OF_MONTH);
         month = date.get(Calendar.MONTH) + 1;
         year = date.get(Calendar.YEAR);
    }
    
    /**
     * ArrayList<ReservationMessage>转换为Json
     */
    public JSONArray arrayListToJSONArray( ArrayList<ReservationMessage> reservationMessages){   
        
        ReservationMessage reservationMessage;
        JSONArray jsonArray = new JSONArray();
        Iterator i=reservationMessages.iterator();
        while(i.hasNext()){
            
            reservationMessage=(ReservationMessage)i.next();
            JSONObject jsonObject=new JSONObject();
            jsonObject.put("reservation_id",reservationMessage.reservation_id);
            if(manager!=null){
               jsonObject.put("room_name",reservationMessage.room.room_name); 
               jsonObject.put("room_id",reservationMessage.room.room_id); 
               
            }
            jsonObject.put("date",reservationMessage.time.year+"/"+reservationMessage.time.month+"/"+reservationMessage.time.day);
            jsonObject.put("username",reservationMessage.user.getUserName());
            jsonObject.put("start",intTimeToString(reservationMessage.time.start));
            jsonObject.put("finish",intTimeToString(reservationMessage.time.finish));
            jsonArray.add(jsonObject);
        }
        return jsonArray;
    }
    
    /**
     * 将数据库中的int类型时间数据转换为String类型数据 如800—>08:00
     * 不足4位在首位补0，添加  ： 时间间隔符
     * 返回类型为String 如 08:00
     */
    public String intTimeToString(int time){
        NumberFormat   formatter   =   NumberFormat.getNumberInstance();   
        formatter.setMinimumIntegerDigits(4);   
        formatter.setGroupingUsed(false);   
        String   Time   =   formatter.format(time);   
        String newTime="";
        for(int i=0;i<Time.length();i++){
                newTime+=Time.charAt(i);
                if(newTime.length()==2){
                    newTime+=":";
                }
        }
        return newTime;
    }
}


