package org.bong.service;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.bong.domain.BoardAttachVO;
import org.bong.domain.BoardVO;
import org.bong.domain.Criteria;
import org.bong.mapper.BoardAttachMapper;
import org.bong.mapper.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Log4j
@Service
//@AllArgsConstructor
public class BoardServiceImpl implements BoardService{

//    private BoardMapper mapper;

    @Setter(onMethod_ = @Autowired)
    private BoardMapper mapper;

    @Setter(onMethod_ = @Autowired)
    private BoardAttachMapper attachMapper;

    @Transactional
    @Override
    public void register(BoardVO board) {
        log.info("register........" +board);
        mapper.insertSelectKey(board);

//        log.info("Register Result : " + result);

        if(board.getAttachList() == null || board.getAttachList().size() <= 0){
//            log.info("no attach!");
            return;
        }


        board.getAttachList().forEach(attach -> {
            attach.setBno(board.getBno());
            attachMapper.insert(attach);

        });
    }

    @Override
    public BoardVO get(Long bno) {
        log.info("get..........."+bno);
        return mapper.read(bno);
    }


    // 서버 측 게시물 수정과 첨부파일
    @Transactional
    @Override
    public boolean modify(BoardVO board) {
        log.info("modify......." +board);
        attachMapper.deleteAll(board.getBno());

        boolean modifyResult = mapper.update(board) == 1;

        if(modifyResult && board.getAttachList() != null && board.getAttachList().size() > 0){
            board.getAttachList().forEach(attach -> {
                attach.setBno(board.getBno());
                attachMapper.insert(attach);
            });
        }

        return modifyResult;
    }

    @Override
    public boolean delete(Long bno) {
       log.info("Delete ........... " +bno);
        return mapper.delete(bno)==1;
    }

//    @Override
//    public List<BoardVO> getList() {
//        log.info("get List .......");
//
//        return mapper.getList();
//    }

    @Override
    public List<BoardVO> getList(Criteria cri){
//        log.info("get List with Paging...");

        return mapper.getListWithPaging(cri);
    }

    @Override
    public int getTotal(Criteria cri){
        return mapper.getTotalCount(cri);
    }

    @Override
    public List<BoardAttachVO> getAttachList(Long bno) {
        log.info("get Attach list by bno : " + bno);
        return attachMapper.findByBno(bno);
    }

    @Transactional
    @Override
    public boolean remove(Long bno){
        log.info("remove ......." + bno);
        attachMapper.deleteAll(bno);
        return mapper.delete(bno) == 1;
    }


}
