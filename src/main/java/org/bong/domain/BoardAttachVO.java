package org.bong.domain;

import lombok.Data;

@Data
public class BoardAttachVO {
    private String uuid;
    private String uploadPath, fileName;
    private Boolean fileType;
    private Long bno;
}
