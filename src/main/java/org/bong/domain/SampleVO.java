package org.bong.domain;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor     //  모든 필드를 배개변수로 받는 생성자 생성
@NoArgsConstructor      //  매개변수가 없는 생성자 생성
public class SampleVO {
    private Integer mno;
    private String firstName;
    private String lastName;

}
