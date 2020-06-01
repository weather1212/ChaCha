<%@page import="java.net.URLDecoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="member.MemberDAO" %>
<!DOCTYPE html>
<html>
<head>
<%
	String memberID = null;
	if(session.getAttribute("memberID") != null ){
		memberID = (String) session.getAttribute("memberID");
	}
	String toID = null;
	if(request.getParameter("toID") != null) {
		toID = (String) request.getParameter("toID");
	}
	if(memberID == null) {
		session.setAttribute("messageType", "오류메시지");
		session.setAttribute("messageContent", "현재 로그인이 되어있지 않습니다.");
		response.sendRedirect("index.jsp");
		return;
	}
	if(toID == null) {
		session.setAttribute("messageType", "오류메시지");
		session.setAttribute("messageContent", "대화상대가 지정되지 않았습니다.");
		response.sendRedirect("index.jsp");
		return;
	}
	if(memberID.equals(URLDecoder.decode(toID, "UTF-8"))){
		session.setAttribute("messageType", "오류메시지");
		session.setAttribute("messageContent", "자기자신에게는 쪽지를 보낼 수 없습니다.");
		response.sendRedirect("index.jsp");
		return;
	}
	String fromProfile = new MemberDAO().getProfile(memberID);  // 내 프로필 
	String toProfile = new MemberDAO().getProfile(toID); 		// 상대 프로필
%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<!-- bootstrap 반응형 viewport 추가 -->
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/custom.css">
	<title>Cha Cha Chat</title>
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script src="js/bootstrap.js"></script>
	<script type="text/javascript">
	
		function autoClosingAlert(selector, delay) {
			var alert = $(selector).alert();
			alert.show();
			window.setTimeout(function() { alert.hide() }, delay);
		}
		
		function submitFunction() {
			var fromID = '<%= memberID %>';
			var toID = '<%= toID %>';
			var chatContent = $('#chatContent').val();
			$.ajax({
				type : "POST",
				url : "./chatSubmitServlet",
				data : {
					fromID : encodeURIComponent(fromID),
					toID : encodeURIComponent(toID),
					chatContent : encodeURIComponent(chatContent)
				},
				success : function(result) {
					if(result == 1){
						autoClosingAlert('#successMessage', 2000);
					} else if(result == 0){
						autoClosingAlert('#dangerMessage', 2000);
					} else {
						autoClosingAlert('#warningMessage', 2000);
					}
				}
			});
			$('#chatContent').val('');
		}
		
		
		var lastID = 0;
		function chatListFunction(type) {
			var fromID ='<%= memberID %>';
			var toID ='<%= toID %>';
			$.ajax({
				type : "POST",
				url : "./chatListServlet",
				data : {
					fromID : encodeURIComponent(fromID),
					toID : encodeURIComponent(toID),
					listType : type
				},
				success: function(data) {
					if(data == "" ) return "";
					var parsed = JSON.parse(data);
					var result = parsed.result;
					for(var i=0; i<result.length; i++) {
						if(result[i][0].value == fromID){
							result[i][0].value = '나';
						}
						addChat(result[i][0].value, result[i][2].value, result[i][3].value);
					}
					lastID = Number(parsed.last);
					}
				});
		}
		
		function addChat(chatName, chatContent, chatTime){
			if(chatName == '나') {
			$('#chatList').append('<div class="row">' +
					'<div class="col-md-6 pull-right" style="background-color:yellow;">' +
					'<div calss="media">' +
					'<a class="pull-left" href="#">' +
					'<img class="media-object img-circle" style="width: 30px; height: 30px;" src="<%= fromProfile %>" alt="">' +
					'</a>' +
					'<div class="media-body">' +
					'<h4 class="media-heading">' +
					chatName + 
					'<span class="small pull-right">' + '<br>' +
					chatTime +
					'</span>' +
					'</h4>' +
					'<p>' +
					chatContent +
					'</p>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'</div>' +
					'<hr style="border-top: 0px;">');
			} else {
				$('#chatList').append('<div class="row">' +
						'<div class="col-lg-6" style="background-color:skyblue;">' +
						'<div calss="media">' +
						'<a class="pull-left" href="#">' +
						'<img class="media-object img-circle" style="width: 30px; height: 30px;" src="<%= toProfile %>" alt="">' +
						'</a>' +
						'<div class="media-body">' +
						'<h4 class="media-heading">' +
						chatName +
						'<span class="small pull-right">' + '<br>' +
						chatTime +
						'</span>' +
						'</h4>' +
						'<p>' +
						chatContent +
						'</p>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'</div>' +
						'<hr style="border-top: 0px;">');
			}
			$('#chatList').scrollTop($('#chatList')[0].scrollHeight);
		}
		function getInfiniteChat() {
			setInterval(function(){
				chatListFunction(lastID);
			}, 1000);
		}	
		
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
				<li><a href="find.jsp">친구찾기</a></li>
				<li ><a href="box.jsp">메시지함<span id="unread" class="label label-info"></span></a></li>
				<li ><a href="boardView.jsp">자유게시판</a></li>
			</ul>
		<% 
			if(memberID != null) {
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
	<div class="container bootstrap snippet">
		<div class="row">
			<div class="col-xs-12">
				<div class="portlet portlet-default">
					<div class="portlet-heading">
						<div class="portlet-title">
							<h4><i class="fa fa-circle text-green"></i>실시간 채팅창	</h4>
						</div>
						<div class="clearfix"></div>
					</div>
					<div id="chat" class="panel-collapse collapse in">
						<div id="chatList" class="portlet-body chat-widget" style="overflow-y:auto; width:auto; height:600px; margin:0px 0px;">
						</div>
						<div class="portlet-footer">
							<div class="row" style="height:90px;">
								<div class="form-group col-xs-10">
									<textarea style="height:80px;" id="chatContent" class="form-control" placeholder="메시지를 입력하세요" maxlength="100"></textarea>
								</div>
								<div class="form-group col-xs-2">
									<button type="button" class="btn btn-default pull-right" onclick="submitFunction();">전송</button>
									<div class="clearfix"></div>
								</div>
							</div>
						</div> 
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="alert alert-success" id="successMessage" style="display:none;">
		<strong>메시지 전송에 성공했습니다.</strong>
	</div>
	<div class="alert alert-danger" id="dangerMessage" style="display:none;">
		<strong>이름과 내용을 모두 입력해주세요.</strong>
	</div>
	<div class="alert alert-warning" id="warningMessage" style="display:none;">
		<strong>데이터베이스 오류</strong>
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
	<script type="text/javascript">
	$(document).ready(function() {
		getUnread();
		chatListFunction('0');
		getInfiniteChat();
		getInfiniteUnread();
	});
	</script>
</body>
</html>