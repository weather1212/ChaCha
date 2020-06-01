<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<!-- bootstrap 반응형 viewport 추가 -->
	<title>Cha Cha Chat</title>
	
</head>
<body>
 <%
 	session.invalidate();
 %>
 <script>
 	location.href = "index.jsp";
 </script>
</body>
</html>