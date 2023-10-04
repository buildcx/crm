package com.xjsf.crm.settings.dao;

import com.xjsf.crm.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserDao {
    User login(Map<String, String> userInfo);

    List<User> getUserList();
}
