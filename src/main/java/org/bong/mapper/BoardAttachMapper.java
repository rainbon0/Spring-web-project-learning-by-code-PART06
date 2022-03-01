package org.bong.mapper;

import org.bong.domain.BoardAttachVO;

import java.util.List;

public interface BoardAttachMapper {
    public int insert(BoardAttachVO vo);

    public void delete(String uuid);

    public List<BoardAttachVO> findByBno(Long bno);

    public void deleteAll(Long bno);

    public List<BoardAttachVO> getOldFiles();
}
