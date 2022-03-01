package org.bong.task;


import lombok.Setter;
import lombok.extern.log4j.Log4j;
import org.bong.domain.BoardAttachVO;
import org.bong.mapper.BoardAttachMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.io.File;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Log4j
@Component
public class FileCheckTask {

    private static final String myUploadPath = "/Users/bongchangyun/upload";

    @Setter(onMethod_ = {@Autowired})
    private BoardAttachMapper attachMapper;

    @Scheduled(cron = "0 * * * * *")  // 매 분 0초가 될 때마다 실행
    //  0 * * * * * (*)
    //  seconds(0~59) / minutes(0~59) / hours(0~23) / day(1~31) / month(1~12) / day of week(1~7) / year(optional)
    //  * 모든 수 / ? 제외 / - 기간 / , 특정 시간 /  / 시작 시간과 반복 시간 / L 마지막 / ₩ 가까운 평일
//        public void checkFiles() throws Exception{
//            log.warn("File Check Task run .................");
//
//            log.warn("==========================================");
//        }

    private String getFolderYesterDay() {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.DATE, -1);
        String str = sdf.format(cal.getTime());

        return str.replace("-", File.separator);
    }

    @Scheduled(cron = "0 0 2 * * *")    // 02:00 active
    public void checkFiles() throws Exception {
        log.warn("File Check Task run .................");
        log.warn(new Date());
        // file list in database
        List<BoardAttachVO> fileList = attachMapper.getOldFiles();

        // ready for check file in directory with database file list
        List<Path> fileListPaths = fileList.stream()
                .map(vo -> Paths.get(myUploadPath, vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName()))
                .collect(Collectors.toList());

        // image file has thumnail file
        fileList.stream().filter(vo -> vo.getFileType())
                .map(vo -> Paths.get(myUploadPath, vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName()))
                .forEach(p -> fileListPaths.add(p));

        log.warn("==========================================");

        fileListPaths.forEach(p -> log.warn(p));

        // files in yesterday directory
        File targetDir = Paths.get(myUploadPath, getFolderYesterDay()).toFile();

        File[] removeFiles = targetDir.listFiles(file -> fileListPaths.contains(file.toPath()) == false );

        log.warn("---------------------------------------");
        for(File file : removeFiles){
            log.warn(file.getAbsolutePath());
            file.delete();
        }


    }
}
