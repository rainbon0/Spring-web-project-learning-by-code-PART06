package org.bong.service;

import org.bong.domain.BoardAttachVO;
import org.bong.domain.BoardVO;
import org.bong.domain.Criteria;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

public interface BoardService {
    public void register(BoardVO board);
    public BoardVO get(Long bno);

    public boolean modify(BoardVO board);

    public boolean delete(Long bno);

//    public List<BoardVO> getList();

    public List<BoardVO> getList(Criteria cri);

    public int getTotal(Criteria cri);

    public List<BoardAttachVO> getAttachList(Long bno);

//    @Transactional
    boolean remove(Long bno);
}
