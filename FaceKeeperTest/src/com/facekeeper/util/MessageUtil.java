package com.facekeeper.util;

import java.util.ArrayList;

import com.facekeeper.dao.MessageDAO;
import com.facekeeper.dto.MessageDTO;
import com.mytechnopal.DTOBase;

public class MessageUtil {

	public String messageContent(String code){
		MessageDAO messageDao = new MessageDAO();
		String message = "";
		ArrayList<DTOBase> messageList = (ArrayList<DTOBase>) messageDao.getMessageListByCode(code);
		for(DTOBase messageObj: messageList){
			MessageDTO messageContent = (MessageDTO)messageObj;
			message = messageContent.getContent();
		}
		return message;
	}
}
