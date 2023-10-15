package com.xjsf.crm.workbench.service.imp;

import com.xjsf.crm.exception.*;
import com.xjsf.crm.settings.dao.UserDao;
import com.xjsf.crm.settings.domain.User;
import com.xjsf.crm.settings.service.UserService;
import com.xjsf.crm.utils.SqlSessionUtil;
import com.xjsf.crm.vo.PageListVO;
import com.xjsf.crm.workbench.dao.ActivityDao;
import com.xjsf.crm.workbench.dao.ActivityRemarkDao;
import com.xjsf.crm.workbench.domain.Activity;
import com.xjsf.crm.workbench.domain.ActivityRemark;
import com.xjsf.crm.workbench.service.ActivityService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ActivityServiceImp implements ActivityService {
    ActivityDao activityDao = SqlSessionUtil.getSqlSession().getMapper(ActivityDao.class);
    ActivityRemarkDao activityRemarkDao = SqlSessionUtil.getSqlSession().getMapper(ActivityRemarkDao.class);
    UserDao userDao = SqlSessionUtil.getSqlSession().getMapper(UserDao.class);

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

    @Override
    public void delete(String[] ids) throws ActivityDeleteException {
        //查询记录数
        int count = activityRemarkDao.getCountByAids(ids);
        //返回删除数
        int deleteCount = activityRemarkDao.DeleteByAids(ids);
        if (count!=deleteCount){
            throw new ActivityDeleteException("删除失败！");
        }
        int count1 = activityDao.delete(ids);
        if (count1!= ids.length){
            throw new ActivityDeleteException("删除失败2！");
        }

    }

    @Override
    public Map<String, Object> getUA(String id) {
        List<User> userList = userDao.getUserList();
        Activity activity = activityDao.getActivity(id);
        Map<String ,Object> map = new HashMap<>();
        map.put("u",userList);
        map.put("a",activity);
        return map;
    }

    @Override
    public void update(Activity activity) throws ActivityUpdateException {
        int count = activityDao.update(activity);
        if(count!=1){
            throw new ActivityUpdateException("修改出错,加班");
        }
    }

    @Override
    public Activity detail(String id) {
        Activity a = activityDao.getDetailByAid(id);
        return a;
    }

    @Override
    public List<ActivityRemark> showRemake(String id) {
        List<ActivityRemark> arl = activityRemarkDao.showRemakeById(id);
        return arl;
    }

    @Override
    public void deleteRemark(String id) throws ActivityRemarkDeleteException {
        int count = activityRemarkDao.deleteById(id);
        if (count!=1){
            throw new ActivityRemarkDeleteException("删除失败！");
        }
    }

    @Override
    public void saveRemark(ActivityRemark activityRemark) throws ActivityRemarkSaveException {
       int i =  activityRemarkDao.saveRemark(activityRemark);
        if (i!=1) {
            throw new ActivityRemarkSaveException("addFail");
        }
    }

    @Override
    public boolean updateRemark(ActivityRemark activityRemark) {
         boolean flag = true;
         int  i = activityRemarkDao.updateRemark(activityRemark);
         if (i!=1){
             flag=false;
         }
        return flag;
    }
}
