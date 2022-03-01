package org.bong.domain;

import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class BoardVO {
    private Long bno;
    private String title, content, writer;
    private Date regDate, updateDate;

    private int replyCnt;

    private List<BoardAttachVO> attachList;
}
