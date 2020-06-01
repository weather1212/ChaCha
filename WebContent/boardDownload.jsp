<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>
<%@ page import="java.io.*" %>
<%@ page import="java.text.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<!-- bootstrap 반응형 viewport 추가 -->
	<title>Cha Cha Chat</title>
	
</head>
<body>
 <%
 	request.setCharacterEncoding("UTF-8");
 	String boardID = request.getParameter("boardID");
 	if(boardID == null || boardID.equals("")) {
 		session.setAttribute("messageType", "오류메시지");
		session.setAttribute("messageContent", "접근할 수 없습니다.");
		response.sendRedirect("index.jsp");
		return;
 	}
 	
 	
 	String root = request.getSession().getServletContext().getRealPath("/"); //실제서버 
 	String savePath = root + "upload";
 	String fileName = "";
 	String realFile = "";
 	
 	BoardDAO boardDAO = new BoardDAO();
 	fileName = boardDAO.getFile(boardID);
 	realFile = boardDAO.getRealFile(boardID);
 	if(fileName.equals("") || fileName == null) {
 		session.setAttribute("messageType", "오류메시지");
		session.setAttribute("messageContent", "접근할 수 없습니다.");
		response.sendRedirect("index.jsp");
		return;
 	}
 	
 	InputStream in = null;
 	OutputStream os = null;
 	File file = null;
 	boolean skip = false;
 	String client = "";
 	try {
 		try {
 			file = new File(savePath, realFile);
 			in = new FileInputStream(file);
 		} catch(FileNotFoundException e) {
 			skip = true;
 		}
 		client = request.getHeader("User-Agent");
 		response.reset();
 		response.setContentType("application/octet-stream");
 		response.setHeader("Content-Description", "JSP Generated Data"); // jsp로 생성한 파일임을 알려주는 것
 		if(!skip){
 			if(client.indexOf("MSIE") != -1) { //마이크로소프트 개발한 브라우저인 경우와 아닌경우 다르게 파일 보내줘야함
 				response.setHeader("Content-Disposition", "attachment; filename=" + new String(fileName.getBytes("KSC5601"), "ISO8859_1"));
 			} else {
 				fileName = new String(fileName.getBytes("UTF-8"), "iso-8859-1");
 				response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
 				response.setHeader("Content-Type", "application/octet-stream; charset = UTF-8");
 			}
 			response.setHeader("Content-Length", "" + file.length());  //file 길이 담아줌
 			os = response.getOutputStream();
 			byte b[] = new byte[(int)file.length()];
 			int leng = 0;
 			while((leng = in.read(b)) > 0) {
 				os.write(b, 0, leng);
 			}
 		} else {
 			response.setContentType("text/html; charset=UTF-8");
 			out.println("<script>alert('파일을 찾을 수 없습니다.'); history.back(); </script>");
 		}
 		in.close();
 		os.close();
 	} catch(Exception e){
 		e.printStackTrace();
 	}
 %>

</body>
</html>