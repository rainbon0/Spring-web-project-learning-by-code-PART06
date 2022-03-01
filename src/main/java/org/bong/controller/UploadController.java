package org.bong.controller;


import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;
import org.bong.domain.AttachFileDTO;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

@Controller
@Log4j
public class UploadController {
    @GetMapping("/uploadForm")
    public void uploadForm(){
        log.info("upload form");

    }

    @PostMapping("/uploadFormAction")
    public void uploadFormPost(MultipartFile[] uploadFile, Model model){
        String uploadFolder = "/Users/bongchangyun/upload";

        for(MultipartFile multipartFile : uploadFile){
            log.info("-----------------------------");
            log.info("Upload File Name : " + multipartFile.getOriginalFilename());
            log.info("Upload File Size : " + multipartFile.getSize());

            File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());

            try {
                multipartFile.transferTo(saveFile);

            } catch (IOException e) {
                log.error(e.getMessage());
            }
        }
    }

    @GetMapping("/uploadAjax")
    public void uploadAjax(){
        log.info("upload ajax");
    }

    @PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_VALUE)
    @ResponseBody
    public ResponseEntity<List<AttachFileDTO>> uploadAjaxAction(MultipartFile[] uploadFile){

        log.info("update ajax post...........");

        List<AttachFileDTO> list = new ArrayList<>();
        String uploadFolder = "/Users/bongchangyun/upload";

        String uploadFolderPath = getFolder();

        // make folder----------
        File uploadPath = new File(uploadFolder, uploadFolderPath);
        log.info("upload path: " + uploadPath);

        if(!uploadPath.exists()){
            uploadPath.mkdirs();
        }
        // make yyyy/MM/dd folder

        for(MultipartFile multipartFile : uploadFile){
            log.info("----------------------------------");
            log.info("Upload File Name : " + multipartFile.getOriginalFilename());
            log.info("Upload File Size : " + multipartFile.getSize());

            AttachFileDTO attachDTO = new AttachFileDTO();

            String uploadFileName = multipartFile.getOriginalFilename();

            // IE has file path
            uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("/")+1);
            log.info("only file name : " + uploadFileName);
            attachDTO.setFileName(uploadFileName);

            UUID uuid = UUID.randomUUID();

            uploadFileName = uuid.toString() + "_" + uploadFileName;



            try {
                //  File saveFile = new File(uploadFolder, uploadFileName);
                File saveFile = new File(uploadPath, uploadFileName);
                multipartFile.transferTo(saveFile);

                attachDTO.setUuid(uuid.toString());
                attachDTO.setUploadPath(uploadFolderPath);

                // check image type file
                // if it's an image => create thumbnail
                if(checkImageType(saveFile)){
                    attachDTO.setImage(true);
                    FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_"+uploadFileName));
                    Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
                    thumbnail.close();
                }
                //add to list
            list.add(attachDTO);
            } catch (IOException e) {
                log.error(e.getMessage());
            }   // end catch
        }
        // end for
        return new ResponseEntity<>(list, HttpStatus.OK);
    }

    private String getFolder(){
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date date = new Date();
        String str = sdf.format(date);

        return str.replace("-",File.separator);
    }

    private boolean checkImageType(File file){
        try {
            String contentType = Files.probeContentType(file.toPath());
            return contentType.startsWith("image");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return false;
    }


    // 이미지 확인
    @GetMapping("/display")
    @ResponseBody
    public ResponseEntity<byte[]> getFile(String fileName){
        log.info("fileName : " + fileName);

        File file = new File("/Users/bongchangyun/upload/" + fileName);

        log.info("file : " + file);

        ResponseEntity<byte[]> result = null;

        try {
            HttpHeaders header = new HttpHeaders();
            header.add("Content-Type", Files.probeContentType(file.toPath()));
            result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
        }catch (IOException e){
            e.printStackTrace();
        }

        return result;
    }

    // MIME type(Multipurpose Internet Mail Extensions)
    //  : 바이너리 데이터인 첨부 파일들을 아스키 코드로 인코딩 하는 방법. 초기에는 이메일을 위해 사용했지만 현재는 웹을 통해 HTTP통신에서 사용되는 다양한 형태의 데이터를 표현하기 위해 사용
    // MIME type은 header 에 Content-type 항목을 추가하여 인코딩하고 있는 데이터의 카테고리를 명시

    // getFile()은 문자열로 파일의 경로가 포함된 fileName을 파라미터로 받고 byte array를 전송
    // byte[]로 이미지 파일의 데이터를 전송할 때 신경 쓰이는 것은 브라우저에 보내주는 MIME 타입이 파일의 종류에 따라 달라지는 점을 신경써야 함
    // header.add("Content-Type", Files.probeContentType(file.toPath()));
    // 위 코드는 http header 메시지에 probeContentType메소드를 통해 브라우저에 보낼 바이너리 파일의 적적한 MIME의 ContentType을 찾는 코드


    // ? - 예제에서는 브라우저에 보낼 바이더리 데이터가 같은 이미지 파일이라도 확장자가 달라 Content-type명시를 해야한다고 설명되어있다.
    //  그렇다면 비디오 파일도 많은 확장자를 가지는데 위와 같은 처리를 해주어야하나?(ex] mp4...)





    @GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
    @ResponseBody
    public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName){   //  Request Header에 있는 User-agent 값을 통해 디바이스 정보를 확인한다.

        log.info("download file : " + fileName);

        Resource resource = new FileSystemResource("/Users/bongchangyun/upload/"+fileName);

        if(resource.exists() == false){
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        String resourceName = resource.getFilename();

        log.info("resource : " + resource);

        // remove UUID
        // _ 기준 뒤쪽 문자열을 resourceOriginalName으로 참조
        String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
        

        HttpHeaders headers = new HttpHeaders();

        try {
            String downloadName = null;
            if(userAgent.contains("Trident")){
                log.info("IE Browser");
                downloadName = URLEncoder.encode(resourceName, "UTF-8").replaceAll("/", " ");
            }else if(userAgent.contains("Edge")){
                log.info("Edge Browser");
                downloadName = URLEncoder.encode(resourceName, "UTF-8");
                log.info("Edge name : " + downloadName);
            }else{
                log.info("Chrome browser");
                downloadName = new String(resourceName.getBytes("UTF-8"), "ISO-8859-1");
            }

            headers.add("Content-Disposition", "attachment; filename="+ downloadName);
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
    }


    // file Delete
    @PostMapping("/deleteFile")
    @ResponseBody
    public ResponseEntity<String> deleteFile(String fileName, String type){
        log.info("deleteFile : " + fileName);
        
        File file;

        try {
            file = new File("/Users/bongchangyun/upload/" + URLDecoder.decode(fileName, "UTF-8"));
            file.delete();
            if(type.equals("image")){
                String largeFileName = file.getAbsolutePath().replace("s_", "");
                log.info("largeFuleName : " + largeFileName);
                file = new File(largeFileName);
                file.delete();

            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }

        return new ResponseEntity<>("deleted", HttpStatus.OK);
    }



}








