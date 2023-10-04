package com.xjsf.crm.settings.web.controller;

import com.xjsf.crm.settings.domain.User;
import com.xjsf.crm.settings.service.UserService;
import com.xjsf.crm.settings.service.imp.UserServiceImp;
import com.xjsf.crm.utils.PrintJson;
import com.xjsf.crm.utils.ServiceFactory;


import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class UserController extends HttpServlet {
    @Override
    protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String servletPath = request.getServletPath();//获取请求的的uri，不带项目名 /settings/user/save.do

        if("/settings/user/login.do".equals(servletPath)){
            System.out.println("进入登录路径");
            login(request,response);
        }
        if ("/xxx".equals(servletPath)){

        }
    }

    private void login(HttpServletRequest request, HttpServletResponse response) {
        String loginAct = request.getParameter("loginAct");
        String loginPwd = request.getParameter("loginPwd");
        String remoteAddr = request.getRemoteAddr();
        UserService userService = (UserService) ServiceFactory.getService(new UserServiceImp());

        try {
            User user =  userService.login(loginAct,loginPwd,remoteAddr);
            request.getSession().setAttribute("User",user);

            PrintJson.printJsonFlag(response,true);

        }catch(Exception e){
            String msg = e.getMessage();
            Map<String , Object> map = new HashMap<>();
            map.put("success",false);
            map.put("msg",msg);
            PrintJson.printJsonObj(response,map);

        }

    }
}
