package com.xjsf.crm.workbench.web.controller;



import com.xjsf.crm.settings.domain.User;
import com.xjsf.crm.settings.service.UserService;
import com.xjsf.crm.settings.service.imp.UserServiceImp;
import com.xjsf.crm.utils.*;
import com.xjsf.crm.vo.PageListVO;
import com.xjsf.crm.workbench.domain.Activity;
import com.xjsf.crm.workbench.domain.ActivityRemark;
import com.xjsf.crm.workbench.service.ActivityService;
import com.xjsf.crm.workbench.service.imp.ActivityServiceImp;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SimpleTimeZone;


public class ActivityController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();//获取请求的的uri，不带项目名 /settings/user/save.do
        String method = request.getMethod();

        if ("/workbench/activity/getUserList.do".equals(servletPath)) {
            System.out.println("getUserList");
            getUserList(request,response);

        } else if ("/workbench/activity/save.do".equals(servletPath)) {
            save(request,response);
        } else if ("/workbench/activity/pageList.do".equals(servletPath)) {
            pageList(request,response);
        } else if ("/workbench/activity/delete.do".equals(servletPath)) {
            delete(request,response);
        } else if ("/workbench/activity/getUserListAndActivity.do".equals(servletPath)) {
            getUserListAndActivity(request,response);
        }else if ("/workbench/activity/update.do".equals(servletPath)){
            update(request,response);
        } else if ("/workbench/activity/detail.do".equals(servletPath)) {
            detail(request,response);
        } else if ("/workbench/activity/showRemark.do".equals(servletPath)) {
            showRemake(request,response);
        } else if ("/workbench/activity/deleteRemark.do".equals(servletPath)) {
            deleteRemark(request,response);
        } else if ("/workbench/activity/saveRemark.do".equals(servletPath)) {
            saveRemark(request,response);
        } else if ("/workbench/activity/updateRemark.do".equals(servletPath)) {
            updateRemark(request,response);
        }

    }

    private void updateRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String content = request.getParameter("noteContent");
        ActivityRemark activityRemark = new ActivityRemark();
        String userName = ((User) request.getSession().getAttribute("User")).getName();
        activityRemark.setEditBy(userName);
        activityRemark.setEditTime(DateTimeUtil.getSysTime());
        activityRemark.setNoteContent(content);
        activityRemark.setId(id);
        activityRemark.setEditFlag("1");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        Map<String,Object> map = new HashMap<>();
        boolean flag = true;
        flag = activityService.updateRemark(activityRemark);
        if (flag){
            map.put("activityRemark",activityRemark);
            map.put("success",flag);
            PrintJson.printJsonObj(response,map);

        }else {
            PrintJson.printJsonFlag(response,false);
        }


    }

    private void saveRemark(HttpServletRequest request, HttpServletResponse response) {
        String yid = request.getParameter("id");
        String remark = request.getParameter("remark");
        String zid = UUIDUtil.getUUID();
        String sysTime = DateTimeUtil.getSysTime();
        String userName = ((User) request.getSession().getAttribute("User")).getName();
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setActivityId(yid);
        activityRemark.setId(zid);
        activityRemark.setNoteContent(remark);
        activityRemark.setCreateTime(sysTime);
        activityRemark.setCreateBy(userName);
        activityRemark.setEditFlag("0");
        Map<String ,Object> map = new HashMap<>();
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        try{
            activityService.saveRemark(activityRemark);
            map.put("ar",activityRemark);
            map.put("success",true);
            PrintJson.printJsonObj(response,map);
        }catch(Exception e){
            e.printStackTrace();
            PrintJson.printJsonFlag(response,false);
        }


    }

    private void deleteRemark(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        Map<String,Object> map = new HashMap<>();
        try{
            activityService.deleteRemark(id);
            map.put("success",true);
            map.put("msg","删除成功！");
            PrintJson.printJsonObj(response,map);
        }catch(Exception e){
            String message = e.getMessage();
            e.printStackTrace();
            map.put("msg",message);
            PrintJson.printJsonObj(response,map);
        }
    }

    private void showRemake(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());

        List<ActivityRemark> activityRL = activityService.showRemake(id);
        PrintJson.printJsonObj(response,activityRL);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        Activity activity = activityService.detail(id);
        request.setAttribute("u",activity);
        request.getRequestDispatcher("detail.jsp").forward(request,response);
    }

    private void update(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description  = request.getParameter("description");
        String editTime = DateTimeUtil.getSysTime();
        String editBy = ((User)request.getSession().getAttribute("User")).getName();

        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setDescription(description);
        activity.setCost(cost);
        activity.setEditTime(editTime);
        activity.setEditBy(editBy);

        try{
            ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());
            activityService.update(activity);
            PrintJson.printJsonFlag(response,true);
        }catch(Exception e){
            e.printStackTrace();
            PrintJson.printJsonFlag(response,false);
        }
    }

    private void getUserListAndActivity(HttpServletRequest request, HttpServletResponse response) {
        String id = request.getParameter("id");
        System.out.println(id);
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        Map<String ,Object> map;
        map = activityService.getUA(id);
        PrintJson.printJsonObj(response,map);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) {
        String[] ids = request.getParameterValues("id");
        Map<String,Object> map = new HashMap<>();
        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        try{
            activityService.delete(ids);
            map.put("success",true);
            map.put("msg","成功删除!");
            PrintJson.printJsonObj(response,map);
        }catch(Exception e){
            e.printStackTrace();
            String msg = e.getMessage();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);
        }
    }

    private void pageList(HttpServletRequest request, HttpServletResponse response) {
        String name = request.getParameter("name");
        String owner = request.getParameter("owner");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String sPageNo = request.getParameter("pageNo");
        Integer pageNo = Integer.valueOf(sPageNo);
        String sPageSize = request.getParameter("pageSize");
        Integer pageSize = Integer.valueOf(sPageSize);
        //计算出忽略的条数
        int skipCount = (pageNo-1)*pageSize;

        //vo对象是后端传给前端的数据展示,故这里使用map
        Map<String,Object> map = new HashMap<>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("pageSize",pageSize);
        map.put("skipCount",skipCount);

        ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());
        PageListVO<Activity> activityPageListVO =activityService.pageList(map);
        PrintJson.printJsonObj(response,activityPageListVO);
    }

    private void save(HttpServletRequest request, HttpServletResponse response) {
        boolean flag = false;
        String id = UUIDUtil.getUUID();
        String owner = request.getParameter("owner");
        String name = request.getParameter("name");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String cost = request.getParameter("cost");
        String description  = request.getParameter("description");
        String createTime = DateTimeUtil.getSysTime();
        String createBy = ((User)request.getSession().getAttribute("User")).getName();

        Activity activity = new Activity();
        activity.setId(id);
        activity.setOwner(owner);
        activity.setName(name);
        activity.setStartDate(startDate);
        activity.setEndDate(endDate);
        activity.setDescription(description);
        activity.setCost(cost);
        activity.setCreateTime(createTime);
        activity.setCreateBy(createBy);

        try {
            ActivityService activityService = (ActivityService) ServiceFactory.getService(new ActivityServiceImp());
            activityService.save(activity);
            flag=true;
            PrintJson.printJsonFlag(response,flag);
        }catch (Exception e){
            PrintJson.printJsonFlag(response,flag);
            e.printStackTrace();
        }
    }

    private void getUserList(HttpServletRequest request, HttpServletResponse response) {

        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImp());
        List<User> ulist =userService.getUserList();
        PrintJson.printJsonObj(response,ulist);

    }

}
