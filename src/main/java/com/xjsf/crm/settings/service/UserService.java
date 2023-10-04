package com.xjsf.crm.settings.service;

import com.xjsf.crm.exception.LoginException;
import com.xjsf.crm.settings.domain.User;

import java.util.List;

public interface UserService {
    User login(String loginAct, String loginPwd, String remoteAddr) throws LoginException;

    List<User> getUserList();
}
