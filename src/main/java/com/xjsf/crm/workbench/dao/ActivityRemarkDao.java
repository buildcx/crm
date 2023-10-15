package com.xjsf.crm.workbench.dao;

import com.xjsf.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkDao {

    int getCountByAids(String[] ids);

    int DeleteByAids(String[] ids);

    List<ActivityRemark> showRemakeById(String id);

    int deleteById(String id);

    int saveRemark(ActivityRemark activityRemark);

    int updateRemark(ActivityRemark activityRemark);
}
