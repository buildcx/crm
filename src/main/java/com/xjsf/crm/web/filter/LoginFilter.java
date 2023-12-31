package com.xjsf.crm.web.filter;

import com.xjsf.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class LoginFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        System.out.println("进入登录验证");
        HttpServletRequest request = (HttpServletRequest)req;
        HttpServletResponse response = (HttpServletResponse)resp;
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("User");
        String servletPath = request.getServletPath();
        if ("/login.jsp".equals(servletPath) || "/settings/user/login.do".equals(servletPath)){
            chain.doFilter(req,resp);
        }else {
            //用户已登录不再拦截
            if (user!=null){
                chain.doFilter(req,resp);
            }else {
                response.sendRedirect(request.getContextPath()+"/login.jsp");
            }
        }


    }

    @Override
    public void destroy() {

    }
}
