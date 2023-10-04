package com.xjsf.crm.workbench.service;

import com.xjsf.crm.exception.ActivitySaveException;
import com.xjsf.crm.settings.domain.User;
import com.xjsf.crm.vo.PageListVO;
import com.xjsf.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    void save(Activity activity) throws ActivitySaveException;

    PageListVO<Activity> pageList(Map<String, Object> map);
}
