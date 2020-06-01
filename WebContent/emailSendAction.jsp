<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.mail.*" %>  
<%@ page import="java.util.Properties"%> 
<%@ page import="member.MemberDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="util.Gmail"%>
<%@ page import="java.io.PrintWriter"%>

<%
	MemberDAO memberDAO = new MemberDAO();
	String memberID = null;
	
	if(session.getAttribute("member") != null) {
		memberID = (String)session.getAttribute("member");
		
	}
	if(memberID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요.!')");
		script.println("location.href = 'login.jsp';");  
		script.println("</script>");
		script.close();
	}

	boolean emailChecked = memberDAO.getMemberEmailChecked(memberID);  //이메일 인증한 회원
	if (emailChecked == true) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이미 인증 된 회원입니다.')");
		script.println("location.href = 'index.jsp';");  //다시 화면으로 돌려주는
		script.println("</script>");
		script.close();	
	} 
	
	String host = "http://localhost:8082/ChaCha/";
	String from = "weather9512@gmail.com";
	String to = memberDAO.getMemberEmail(memberID);	
	String subject = "회원가입 위한 이메일 인증 메일입니다.";
	String content = "다음 링크에 접속하여 이메일을 인증해주세요!" +
					"<a href = '" + host + "emailCheckAction.jsp?code=" + new SHA256().getSHA256(to) + "'> 이메일 인증하기</a>";
	
	Properties p = new Properties();
	p.put("mail.smtp.user", from);
	p.put("mail.smtp.host", "smtp.googlemail.com");
	p.put("mail.smtp.port", "465");
	p.put("mail.smtp.starttls.enable", "true");
	p.put("mail.smtp.auth", "true");
	p.put("mail.smtp.debug", "true");
	p.put("mail.smtp.socketFactory.port", "465");
	p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	p.put("mail.smtp.socketFactory.fallback", "false");
	
	try {
		Authenticator auth = new Gmail();
		Session ses = Session.getInstance(p, auth);
		ses.setDebug(true);
		MimeMessage msg = new MimeMessage(ses);
		msg.setSubject(subject);
		Address fromAddr = new InternetAddress(from);
		msg.setFrom(fromAddr);
		Address toAddr = new InternetAddress(to);
		msg.addRecipient(Message.RecipientType.TO, toAddr);
		msg.setContent(content, "text/html;charset=UTF-8");
		Transport.send(msg);
	} catch (Exception e){
		e.printStackTrace();
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('오류가 발생했습니다.')");
		script.println("history.back();");  
		script.println("</script>");
		script.close();
	}
	
%>
<!DOCTYPE html>
<html>
<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<!-- bootstrap 반응형 viewport 추가 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">
<title>Cha Cha Chat</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="js/bootstrap.js"></script>
		
</head>
<body>
		
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed"
			data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="index.jsp">Cha Cha Chat</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="index.jsp">메인</a></li>
				<li><a href="find.jsp">친구찾기</a></li>
			</ul>
			<%
				if(memberID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
					접속하기<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li class="active"><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul>	
					
				</li>	
			</ul>
			<%
				}
			%>
		</div>
	</nav>	
			<section class="container mt-3" style="max-width: 560px;">
				<div class="alert alert-success mt-4" role="alert">
					이메일 주소 인증 메일이 전송되었습니다. <br>
					입력했던 이메일에 들어가서 인증해주세요.
				</div>
			</section>
			
			<!-- 제이쿼리 자바스크립트 추가하기 -->
			<script src="http://code.jquery.com/jquery-latest.min.js"></script> 
			<script src="./js/bootstrap.min.js"></script>
</body>
</html>
