package org.bong.domain;

import lombok.Data;

import java.util.Date;

@Data
public class ReplyVO {
    private Long rno, bno;

    private String reply;
    private String replyer;

    private Date replyDate, updateDate;

}
