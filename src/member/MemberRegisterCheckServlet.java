package member;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/MemberRegisterCheckServlet")
public class MemberRegisterCheckServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String memberID = request.getParameter("memberID");
		if(memberID == null || memberID.equals("")) response.getWriter().write("-1");
		response.getWriter().write(new MemberDAO().registerCheck(memberID) + ""); //문자열로 반환해주기 위해 "" 추가
		
		//중복체크 servlet
	}

}
