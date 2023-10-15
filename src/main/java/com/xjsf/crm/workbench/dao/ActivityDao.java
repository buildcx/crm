package com.xjsf.crm.workbench.dao;

import com.xjsf.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int save(Activity activity);

    int pageListCount(Map<String, Object> map);

    List<Activity> pageListInfo(Map<String, Object> map);

    int delete(String[] ids);

    Activity getActivity(String id);

    int update(Activity activity);

    Activity getDetailByAid(String id);
}
