package com.xjsf.crm.workbench.service.imp;

import com.xjsf.crm.exception.ActivitySaveException;
import com.xjsf.crm.settings.dao.UserDao;
import com.xjsf.crm.settings.domain.User;
import com.xjsf.crm.utils.SqlSessionUtil;
import com.xjsf.crm.vo.PageListVO;
import com.xjsf.crm.workbench.dao.ActivityDao;
import com.xjsf.crm.workbench.domain.Activity;
import com.xjsf.crm.workbench.service.ActivityService;

import java.util.List;
import java.util.Map;

public class ActivityServiceImp implements ActivityService {
    ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);

    @Override
    public void save(Activity activity) throws ActivitySaveException {
        int count=activityDao.save(activity);
        if (count!=1){
            throw new ActivitySaveException("发生未知异常,数据保存失败！");
        }
    }

    @Override
    public PageListVO<Activity> pageList(Map<String, Object> map) {
        int total = activityDao.pageListCount(map);
        List<Activity> activity = activityDao.pageListInfo(map);
        PageListVO<Activity> activityPageListVO = new PageListVO<>();
        activityPageListVO.setTotal(total);
        activityPageListVO.setPagelist(activity);
        return activityPageListVO;
    }
}
