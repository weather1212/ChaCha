<%@page import="java.io.PrintWriter"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.MemberDAO" %>

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
	<script type="text/javascript"> 
		
	
	function registerCheckFunction() {
			var memberID = $('#memberID').val();
			setTimeout
			$.ajax({
				type : 'POST',
				url : './MemberRegisterCheckServlet',
				data : {memberID : memberID},
				success : function(result){
					if(result == 1) {
						$('#checkMessage').html('사용할 수 있는 아이디 입니다.');
						$('#checkType').attr('class', 'modal-content panel-success');
					} else {
						$('#checkMessage').html('사용할 수 없는 아이디 입니다.');
						$('#checkType').attr('class', 'modal-content panel-warning');
					}
					$('#checkModal').modal("show");
				} 
			});
		}
	
		function passwordCheckFunction(){
			var memberPassword1 = $('#memberPassword1').val();
			var memberPassword2 = $('#memberPassword2').val();
			if(memberPassword1 != memberPassword2){
				$('#passwordCheckMessage').html('비밀번호가 일치하지 않습니다.');
			} else {
				$('#passwordCheckMessage').html('');
			}
		}
	</script>
</head>
<body>
<%
	String memberID = null;
	if(session.getAttribute("memberID") != null ){
		memberID = (String) session.getAttribute("memberID");
	}

	if(memberID != null) {
		session.setAttribute("messageType", "오류메시지");
		session.setAttribute("messageContent", "현재 로그인이 되어있는 상태입니다.");
		response.sendRedirect("index.jsp");
		return;
	}
	
%>

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
				<li ><a href="box.jsp">메시지함<span id="unread" class="label label-info"></span></a></li>
				<li ><a href="boardView.jsp">자유게시판</a></li>
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
						<li><a href="login.jsp">로그인</a></li>
						<li class="active"><a href="join.jsp">회원가입</a></li>
					</ul>	
					
				</li>	
			</ul>
			<%
				}
			%>
		</div>
	</nav>	
	<div class="container join">
		<form method="post" action="./memberRegister">
			<table class="table table-bordered table-hover" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th colspan="3"><h4>회원가입</h4></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th style="width: 110px;"><h5>아이디</h5></th>
						<td><input class="form-control" type="text" id="memberID" name="memberID" maxlength="20" placeholder="아이디를 입력하세요">
						<td style="width: 110px;"><button class="btn btn-primary" onclick="registerCheckFunction();" type="button">중복체크</button></td>
					</tr>
					<tr>
						<th style="width: 110px;"><h5>비밀번호</h5></th>
						<td colspan="2"><input onkeyup="passwordCheckFunction();" class="form-control" type="password" id="memberPassword1" name="memberPassword1" maxlength="20" placeholder="비밀번호를 입력하세요"></td>
					</tr>				<!-- onkeyup = 비밀번호 입력할 때마다 실행 -->
					<tr>
						<th style="width: 120px;"><h5>비밀번호확인</h5></th>
						<td colspan="2"><input onkeyup="passwordCheckFunction();" class="form-control" type="password" id="memberPassword2" name="memberPassword2" maxlength="20" placeholder="비밀번호 확인"></td>
					</tr>
					<tr>
						<th style="text-align : left;" colspan="3"><h5 style="color: red;" id="passwordCheckMessage"></h5></th>
						
					</tr>
					<tr>
						<th style="width: 110px;"><h5>이름</h5></th>
						<td colspan="2"><input class="form-control" type="text" id="memberName" name="memberName" maxlength="20" placeholder="이름을 입력하세요"></td>
					</tr>
					<tr>
						<th style="width: 110px;"><h5>이메일</h5></th>
						<td colspan="2"><input class="form-control" type="email" id="memberEmail" name="memberEmail" maxlength="20" placeholder="이메일을 입력하세요"></td>
					</tr>
				</tbody>	
			</table>
			<input class="btn btn-primary pull-right" type="submit" value="회원가입">	
		</form>
	</div>			
	
	<%
		String messageType = null;
		if(session.getAttribute("messageType") != null) {
			messageType = (String) session.getAttribute("messageType");
		}
	
		String messageContent = null;
		if(session.getAttribute("messageContent") != null) {
			messageContent = (String) session.getAttribute("messageContent");
		}
		if(messageContent != null) {
	%>
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div class="modal-content <%if(messageType.equals("오류 메시지")) out.println("panel-warning"); else out.println("panel-success"); %>">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							<%=messageType %>
						</h4>
					</div>
					<div class="modal-body">
						<%=messageContent %>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>
		$('#messageModal').modal("show");
	</script>
	<% 		
		session.removeAttribute("messageType");
		session.removeAttribute("messageContent");
	
		}
	%>
	<!--  중복확인 했을 때 메세지 출력 Ajax로 값 보내는 거 -->
	<div class="modal fade" id="checkModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div id="checkType" class="modal-content panel-info">  
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							확인 메시지
						</h4>
					</div>
					<div id="checkMessage" class="modal-body">
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-primary" data-dismiss="modal">확인</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>