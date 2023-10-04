package com.xjsf.crm.vo;

import java.util.List;

public class PageListVO<T> {
    private int total;
    private List<T> pagelist;

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }

    public List<T> getPagelist() {
        return pagelist;
    }

    public void setPagelist(List<T> pagelist) {
        this.pagelist = pagelist;
    }
}
