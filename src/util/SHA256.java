package util;

import java.security.MessageDigest;

public class SHA256 { //이메일인증
	
	public static String getSHA256(String input) {
		StringBuffer result = new StringBuffer();
		try {
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			byte[] salt = "Hello! This is Salt.".getBytes(); //해킹으로부터 보호하는 
			digest.reset();
			digest.update(salt);
			byte[] chars = digest.digest(input.getBytes("UTF-8"));
			for(int i=0; i<chars.length; i++) {
				String hex = Integer.toHexString(0xff & chars[i]);
				if(hex.length() == 1) result.append("0");  // 두자리수 16진수 형태
				result.append(hex);
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
		return result.toString();
	}
}
