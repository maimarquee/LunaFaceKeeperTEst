package com.facekeeper.dto;

import com.mytechnopal.DTOBase;

public class MessageDTO extends DTOBase {
	private static final long serialVersionUID = 1L;

	public static final String SESSION_MESSAGE_TIME = "SESSION_MESSAGE_TIME";
	public static final String DEFAULT_CODE = "0001"; //if you add character to default code you alter getLastCodeMinusOne() method in MainController.java
	public static final String DEFAULT_TIME = "33000"; //33000 //LENGHT OF SECONDS THAT FaceKeeper Powered by Technopal Software RUNS THE ENTIRE MARQUEE
	public static final String DEFAULT_NUMBERS_OF_TEXT_IN_A_SECOND = "5";// NUMBER OF TEXT PER SECOND 3.5
	
	private String content;

	public MessageDTO() {
		super();
		this.content = "";
	}

	public MessageDTO getMessage(){
		MessageDTO message = new MessageDTO();
		message.setId(super.getId());
		message.setCode(super.getCode());
		message.setContent(this.content);
		return message;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
}