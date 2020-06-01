package chat;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import member.MemberDAO;


@WebServlet("/ChatBoxServlet")
public class ChatBoxServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
 
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		String memberID = request.getParameter("memberID");
		
		if(memberID == null || memberID.equals("")) {
			response.getWriter().write("");
		} else {
			try {
				HttpSession session = request.getSession();  //다른 사용자 접근 못하게 막는
				
				if(!URLDecoder.decode(memberID, "UTF-8").equals((String) session.getAttribute("memberID"))) {
					response.getWriter().write("");
					return;
				}
				
				memberID = URLDecoder.decode(memberID, "UTF-8");
				response.getWriter().write(getBox(memberID));
			} catch(Exception e) {
				response.getWriter().write("");
			}
			
		}
	
	}
	
	public String getBox(String memberID) {
		StringBuffer result = new StringBuffer("");
		result.append("{\"result\":[");
		ChatDAO chatDAO = new ChatDAO();
		ArrayList<ChatDTO> chatList = chatDAO.getBox(memberID);
		if(chatList.size() == 0) return "";
		for(int i=chatList.size() -1 ; i >= 0; i--) {
			String unread = "";
			String memberProfile ="";
			if(memberID.equals(chatList.get(i).getToID())) {
				unread = chatDAO.getUnreadChat(chatList.get(i).getFromID(), memberID) + "";
				if(unread.equals("0")) unread = "";
			}
			if(memberID.equals(chatList.get(i).getToID())) {
				memberProfile = new MemberDAO().getProfile(chatList.get(i).getFromID());
			} else {
				memberProfile = new MemberDAO().getProfile(chatList.get(i).getToID());
			}
			result.append("[{\"value\": \"" + chatList.get(i).getFromID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getToID() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatContent() + "\"},");
			result.append("{\"value\": \"" + chatList.get(i).getChatTime() + "\"},");
			result.append("{\"value\": \"" + unread + "\"},");
			result.append("{\"value\": \"" + memberProfile + "\"}]");
			if(i != 0 ) result.append(",");
		}
		result.append("], \"last\":\"" + chatList.get(chatList.size() -1).getChatID() + "\"}");
		return result.toString();
	}

}

	
