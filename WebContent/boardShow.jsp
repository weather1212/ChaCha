<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.MemberDAO" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardDTO" %>

<!DOCTYPE html>
<html>
<%
	String memberID = null;
	if(session.getAttribute("memberID") != null ){
		memberID = (String) session.getAttribute("memberID");
	}
	MemberDAO memberDAO = new MemberDAO();
	
	if(memberDAO.getMemberEmailChecked(memberID) == false) {
		memberID = null;
	}
	
	if(memberID == null) {
		session.setAttribute("messageType", "오류메시지");
		session.setAttribute("messageContent", "현재 로그인이 되어있지 않습니다.");
		response.sendRedirect("index.jsp");
		return;
	}
	
	String boardID = null;
	if(request.getParameter("boardID") != null ){
		boardID = (String) request.getParameter("boardID");
	}
	
	if(boardID == null || boardID.equals("")){
		session.setAttribute("messageType", "오류메시지");
		session.setAttribute("messageContent", "게시물이 존재하지 않습니다.");
		response.sendRedirect("index.jsp");
		return;
	}
	
	BoardDAO boardDAO = new BoardDAO();
	BoardDTO board = boardDAO.getBoard(boardID);
	boardDAO.hit(boardID);

%>
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
		function getUnread() {
			$.ajax({
				type : "POST",
				url : "./chatUnread",
				data : {
					memberID: encodeURIComponent('<%= memberID%>'),
				},
				success : function(result){
					if(result >= 1){
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
		function showUnread(result){
			$('#unread').html(result);
		}
	</script>
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
				<li ><a href="find.jsp">친구찾기</a></li>
				<li ><a href="box.jsp">메시지함<span id="unread" class="label label-info"></span></a></li>
				<li class="active"><a href="boardView.jsp">자유게시판</a></li>
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
						<li><a href="join.jsp">회원가입</a></li>
					</ul>	
					
				</li>	
			</ul>
			<%
			} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" 
					aria-expanded="false">회원관리<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li><a href="update.jsp">화원정보수정</a></li>
						<li><a href="profileUpdate.jsp">프로필수정</a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>	
				</li>	
			</ul>
			<%
			}
			%>
		</div>
	</nav>		
	<div class="container">
		<table class="table table-bordered table-hover" style="text-align:center; border: 1px solid #dddddd">
			<thead>
				<tr>
					<th colspan="4"><h4>게시물 상세</h4></th>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>제목</h5></td>
					<td colspan="3"><h5><%=board.getBoardTitle() %></h5>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>작성자</h5></td>
					<td colspan="3"><h5><%=board.getMemberID() %></h5>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>작성날짜</h5></td>
					<td><h5><%=board.getBoardDate() %></h5>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>조회수</h5></td>
					<td><h5><%=board.getBoardHit() %></h5>
				</tr>
				<tr>
					<td style="vertical-align:middle; min-height: 150px; background-color: #fafafa; color: #000000; width: 80px;"><h5>내용</h5></td>
					<td colspan="3" style="text-align: left;"><h5><%=board.getBoardContent() %></h5>
				</tr>
				<tr>
					<td style="background-color: #fafafa; color: #000000; width: 80px;"><h5>첨부파일</h5></td>
					<td colspan="3"><h5><a href="boardDownload.jsp?boardID=<%=board.getBoardID() %>"><%= board.getBoardFile() %></a></h5>
				</tr>
			</thead>
		</table>
		
		<a href="boardView.jsp" class="btn btn-primary pull-right">목록</a>
		<%-- <a href="boardReply.jsp?boardID=<%=board.getBoardID() %>" class="btn btn-primary pull-right">댓글</a> --%>
		
		<% 
			if(memberID.equals(board.getMemberID())){	
		%>
		<a href="boardUpdate.jsp?boardID=<%=board.getBoardID() %>" class="btn btn-primary pull-right">수정</a>
		<a href="boardDelete?boardID=<%=board.getBoardID() %>" class="btn btn-primary pull-right" onclick="return confirm('정말로 삭제하시겠습니까?');">삭제</a>
		<%
			}
		%>
		
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
	<%
		if(memberID != null) {
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
</body>
</html>