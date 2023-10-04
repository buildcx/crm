package com.xjsf.crm.workbench.web.controller;



import com.xjsf.crm.settings.domain.User;
import com.xjsf.crm.settings.service.UserService;
import com.xjsf.crm.settings.service.imp.UserServiceImp;
import com.xjsf.crm.utils.DateTimeUtil;
import com.xjsf.crm.utils.PrintJson;
import com.xjsf.crm.utils.ServiceFactory;
import com.xjsf.crm.utils.UUIDUtil;
import com.xjsf.crm.vo.PageListVO;
import com.xjsf.crm.workbench.domain.Activity;
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

        //vo对象是后端传给前端的数据展示
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
