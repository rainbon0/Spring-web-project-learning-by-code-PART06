package org.bong.service;


import org.bong.domain.Criteria;
import org.bong.domain.ReplyPageDTO;
import org.bong.domain.ReplyVO;

import java.util.List;

public interface ReplyService {
    public int register(ReplyVO vo);

    public int modify(ReplyVO vo);

    public int remove (Long rno);

    public ReplyVO get(Long rno);

    public List<ReplyVO> getList(Criteria cri, Long bno);

    public ReplyPageDTO getListPage(Criteria cri, Long bno);

}
