<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="member.MemberDAO"%>
<%@ page import="util.SHA256"%>
<%@ page import="java.io.PrintWriter"%>

<%
	request.setCharacterEncoding("UTF-8");
	String code = null;
	MemberDAO memberDAO = new MemberDAO();
	String memberID = null;
	
	if(session.getAttribute("member") != null) {
		memberID = (String)session.getAttribute("member");
	}
	
	if(memberID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 해주세요')");
		script.println("location.href='login.jsp';");  //다시 화면으로 돌려주는
		script.println("</script>");
		script.close();	
	}
	
	if(request.getParameter("code") != null) {
		code = request.getParameter("code");
	}
	
	

	String memberEmail = memberDAO.getMemberEmail(memberID);
	boolean isRight = (new SHA256().getSHA256(memberEmail).equals(code)) ? true : false ;
	
	if(isRight == true){
		memberDAO.setMemberEmailChecked(memberID);  //이메일 인증처리해주는 함수
		request.getSession().setAttribute("memberID", memberID);
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('이메일 인증에 성공했습니다.');");
		script.println("location.href = 'index.jsp';");  //다시 화면으로 돌려주
		script.println("</script>");
		script.close();	
		
	} else {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('유효하지 않은 코드입니다.');");
		script.println("location.href = 'index.jsp';");  //다시 화면으로 돌려주는
		script.println("</script>");
		script.close();	
	}
	
%>
