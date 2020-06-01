<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.MemberDAO"%>

<!DOCTYPE html>
<html>
<%
	String memberID = null;
	if (session.getAttribute("memberID") != null) {
		memberID = (String) session.getAttribute("memberID");
		System.out.print(memberID);
	}
	MemberDAO memberDAO = new MemberDAO();

	if (memberDAO.getMemberEmailChecked(memberID) == false) {
		memberID = null;
	}
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- bootstrap 반응형 viewport 추가 -->
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/index.css">
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">

<title>Cha Cha Chat</title>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script src="js/bootstrap.js"></script>
<script type="text/javascript">
		function getUnread() {
			$.ajax({
				type : "POST",
				url : "./chatUnread",
				data : {
					memberID: encodeURIComponent('<%=memberID%>'),
			},
			success : function(result) {
				if (result >= 1) {
					showUnread(result);
				} else {
					showUnread('');
				}
			}
		});
	}

	function getInfiniteUnread() {
		setInterval(function() {
			getUnread();
		}, 4000);
	}
	function showUnread(result) {
		$('#unread').html(result);
	}
</script>
</head>
<body>
	<input type="hidden" id="session_id" value="${sessionScope.memberID }">

	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse"
				data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="index.jsp">Cha Cha Chat</a>
		</div>
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li class="active"><a href="index.jsp">메인</a></li>
				<li><a href="find.jsp">친구찾기</a></li>
				<li><a href="box.jsp">
						메시지함
						<span id="unread" class="label label-info"></span>
					</a></li>
				<li><a href="boardView.jsp">자유게시판</a></li>
			</ul>
			<%
				if (memberID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown"
						role="button" aria-haspopup="true" aria-expanded="false">
						접속하기
						<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul></li>
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown"
						role="button" aria-haspopup="true" aria-expanded="false">
						<%=memberID%>
						<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="update.jsp">화원정보수정</a></li>
						<li><a href="profileUpdate.jsp">프로필수정</a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul></li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>

	<%
		String messageType = null;
		if (session.getAttribute("messageType") != null) {
			messageType = (String) session.getAttribute("messageType");
		}

		String messageContent = null;
		if (session.getAttribute("messageContent") != null) {
			messageContent = (String) session.getAttribute("messageContent");
		}
		if (messageContent != null) {
	%>
	<div class="modal fade" id="messageModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="vertical-alignment-helper">
			<div class="modal-dialog vertical-align-center">
				<div
					class="modal-content <%if (messageType.equals("오류 메시지"))
					out.println("panel-warning");
				else
					out.println("panel-success");%>">
					<div class="modal-header panel-heading">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&times</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title">
							<%=messageType%>
						</h4>
					</div>
					<div class="modal-body">
						<%=messageContent%>
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
	<%
		if (memberID != null) {
	%>
	<script type="text/javascript">
		$(document).ready(function() {
			getUnread();
			getInfiniteUnread();
		});
	</script>

	<%
		}
	%>

	<div class="js-weather weather"></div>
	<div class="content">
		<div class="js-clock clock">
			<h1 class="js-clock clock"></h1>
		</div>
		<h2 class="js-greetings greetings"></h2>
	</div>

	<script type="text/javascript" src="js/clock.js"></script>
	<script type="text/javascript" src="js/greet.js"></script>
	<script type="text/javascript" src="js/bg.js"></script>
	<script type="text/javascript" src="js/weather.js"></script>
</body>
</html>