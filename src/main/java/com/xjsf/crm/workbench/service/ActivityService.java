package com.xjsf.crm.workbench.service;

import com.xjsf.crm.exception.*;
import com.xjsf.crm.settings.domain.User;
import com.xjsf.crm.vo.PageListVO;
import com.xjsf.crm.workbench.domain.Activity;
import com.xjsf.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    void save(Activity activity) throws ActivitySaveException;

    PageListVO<Activity> pageList(Map<String, Object> map);

    void delete(String[] ids) throws ActivityDeleteException;

    Map<String, Object> getUA(String id);

    void update(Activity activity) throws ActivityUpdateException;

    Activity detail(String id);

    List<ActivityRemark> showRemake(String id);

    void deleteRemark(String id) throws ActivityRemarkDeleteException;

    void saveRemark(ActivityRemark activityRemark) throws ActivityRemarkSaveException;

    boolean updateRemark(ActivityRemark activityRemark);

}
