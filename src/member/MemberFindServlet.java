package member;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/MemberFindServlet")
public class MemberFindServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String memberID = request.getParameter("memberID");
		
		if(memberID == null || memberID.equals("")) {
			response.getWriter().write("-1");
		} else if(new MemberDAO().registerCheck(memberID) == 0) {
			try {
				response.getWriter().write(find(memberID));
			} catch(Exception e) {
				response.getWriter().write("-1");
			}
		} else {
			response.getWriter().write("-1");
		}
	}

	public String find(String memberID) {
		StringBuffer result = new StringBuffer("");
		result.append("{\"memberProfile\":\"" + new MemberDAO().getProfile(memberID) + "\"}");
		return result.toString();
	}
}
