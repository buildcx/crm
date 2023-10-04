package com.xjsf.crm.settings.service.imp;

import com.xjsf.crm.exception.LoginException;
import com.xjsf.crm.settings.dao.UserDao;
import com.xjsf.crm.settings.domain.User;
import com.xjsf.crm.settings.service.UserService;
import com.xjsf.crm.utils.DateTimeUtil;
import com.xjsf.crm.utils.MD5Util;
import com.xjsf.crm.utils.SqlSessionUtil;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class UserServiceImp implements UserService {
    private UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);


    @Override
    public User login(String loginAct, String loginPwd, String remoteAddr) throws LoginException {
        Map<String ,String> userInfo = new HashMap<>();
        loginPwd = MD5Util.getMD5(loginPwd);
        userInfo.put("loginAct",loginAct);
        userInfo.put("loginPwd",loginPwd);
        User user = userDao.login(userInfo);

        if (user==null){
            throw new LoginException("用户账号或密码错误！");
        }

        //验证失效时间
        String sysTime = DateTimeUtil.getSysTime();
        if (sysTime.compareTo(user.getExpireTime())>0){
            throw new LoginException("有效登录时间已失效！");
        }

        //验证锁定状态
        if ("0".equals(user.getLockState())){
            throw new LoginException("账号已被锁定，请联系管理员");
        }

        //验证ip地址
        if (!user.getAllowIps().contains(remoteAddr)){
            throw new LoginException("ip地址受限");
        }

        return user;
    }

    @Override
    public List<User> getUserList() {
        List<User> uList = userDao.getUserList();
        return uList;
    }
}
