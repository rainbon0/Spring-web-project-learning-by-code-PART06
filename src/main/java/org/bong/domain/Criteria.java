package org.bong.domain;


import lombok.Data;
import org.springframework.web.util.UriComponentsBuilder;

@Data //    getter, setter, toString 전부 포함
public class Criteria { //  검색의 기준
    private int pageNum;
    private int amount;

    private static final int defaultPageNum = 1;
    private static final int defaultAmount = 10;

    private String type;
    private String keyword;

    public Criteria(){
        this(defaultPageNum,defaultAmount); // 기본값을 1페이지, 10개 로 설정.
                                    //  다른 생성자를 1, 10 을 인자로 호출
    }

    public Criteria(int pageNum, int amount){
        this.pageNum = pageNum;
        this.amount = amount;
    }

    public String[] getTypeArr(){
        return type == null ? new String[]{} : type.split("");
    }

    public String getListLink(){
        UriComponentsBuilder builder = UriComponentsBuilder.fromPath("")
                .queryParam("pageNum", this.pageNum)
                .queryParam("amount", this.getAmount())
                .queryParam("type", this.getType())
                .queryParam("keyword", this.getKeyword());
        return builder.toUriString();
    }

}
