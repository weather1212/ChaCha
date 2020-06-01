package member;

import java.io.IOException;
import java.io.PrintWriter;

import javax.mail.Session;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.SHA256;


@WebServlet("/MemberRegisterServlet")
public class MemberRegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String memberID = request.getParameter("memberID");
		String memberPassword1 = request.getParameter("memberPassword1");
		String memberPassword2 = request.getParameter("memberPassword2");
		String memberName = request.getParameter("memberName");
		String memberEmail = request.getParameter("memberEmail");
		String memberProfile = request.getParameter("memberProfile");
		
		if(memberID == null || memberPassword1 == null || memberPassword2 == null || memberName == null ||
				memberEmail == null || memberID.equals("") || memberPassword1.equals("") || 
				memberPassword2.equals("") || memberName.equals("") || memberEmail.equals("")) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "모든 내용을 입력해주세요.");
			response.sendRedirect("join.jsp");
			return;
		}
		if(!memberPassword1.equals(memberPassword2)) {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "비밀번호가 서로 다릅니다.");
			response.sendRedirect("join.jsp");
			return;
		}
		int result = new MemberDAO().register(memberID, memberPassword1, memberName, memberEmail, memberProfile, SHA256.getSHA256(memberEmail),false);
		System.out.println(result);
		if (result == 1) {
			 request.getSession().setAttribute("member", memberID);
			/*
			 * request.getSession().setAttribute("messageType", "성공 메시지");
			 * request.getSession().setAttribute("messageContent", "회원가입에 성공했습니다.");
			 */
			response.sendRedirect("emailSendAction.jsp");
			return;
		} else {
			request.getSession().setAttribute("messageType", "오류 메시지");
			request.getSession().setAttribute("messageContent", "이미 존재하는 회원입니다.");
			response.sendRedirect("join.jsp");
			return;
		}
	}

}
