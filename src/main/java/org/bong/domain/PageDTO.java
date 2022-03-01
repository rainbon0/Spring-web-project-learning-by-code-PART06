package org.bong.domain;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
    private int startPage, endPage, total;
    private boolean prev, next;

    private static final int perPageAmount = 10;   //  한 번에 표기할 페이지 수 (1~10, 11~20)

    private Criteria cri;   // 현재 페이지 수, 한 번에 표기할 데이터 수

    public PageDTO(Criteria cri, int total){
        this.cri = cri;
        this.total = total;

        this.endPage = (int)(Math.ceil(cri.getPageNum() / (double)perPageAmount))* perPageAmount;
        this.startPage = endPage - (perPageAmount-1);

        int realEnd = (int)(Math.ceil(total / cri.getAmount()));
        // 마지막 페이지 그룹에서 작동
        if(realEnd < this.endPage){
            this.endPage = realEnd;
        }

        this.next = this.endPage < realEnd;
        this.prev = this.startPage > 1;
    }

}
