package member;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@WebServlet("/MemberUpdateServlet")
public class MemberUpdateServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String memberID = request.getParameter("memberID");
		
		HttpSession session = request.getSession();
		
		String memberPassword1 = request.getParameter("memberPassword1");
		String memberPassword2 = request.getParameter("memberPassword2");
		String memberName = request.getParameter("memberName");
		String memberEmail = request.getParameter("memberEmail");
		
		if(memberID == null || memberPassword1 == null || memberPassword2 == null || memberName == null ||
				memberEmail == null || memberID.equals("") || memberPassword1.equals("") || 
				memberPassword2.equals("") || memberName.equals("") || memberEmail.equals("")) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "모든 내용을 입력해주세요.");
			response.sendRedirect("update.jsp");
			return;
		}
		
		if(!memberID.equals((String) session.getAttribute("memberID"))) {
			session.setAttribute("messageType", "오류메시지");
			session.setAttribute("messageContent", "다른 사용자는 접근할 수 없습니다.");
			response.sendRedirect("index.jsp");
			return;
		}
		
		if(!memberPassword1.equals(memberPassword2)) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "비밀번호가 서로 다릅니다.");
			response.sendRedirect("update.jsp");
			return;
		}
		int result = new MemberDAO().update(memberID, memberPassword1, memberName, memberEmail);
		if (result == 1) {
			request.getSession().setAttribute("memberID", memberID);
			request.getSession().setAttribute("messageType", "성공 메시지");
			request.getSession().setAttribute("messageContent", "회원정보수정에 성공했습니다.");
			response.sendRedirect("index.jsp");
			return;
		} else {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "데이터베이스 오류 발생");
			response.sendRedirect("update.jsp");
			return;
		}
	}

}
