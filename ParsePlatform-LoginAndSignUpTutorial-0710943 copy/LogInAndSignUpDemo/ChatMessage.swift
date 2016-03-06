//
//  ChatMessage.swift
//  Keap
//
//  Created by Michael Zuccarino on 2/27/16.
//
//

import UIKit

class ChatMessage: NSObject {
    
    var sender:KeapUser?
    var message:String?
    var timestamp:NSDate?
    var seen:Bool = true
    
    func messageWithAPIResult(rawMessage message:NSDictionary?) -> ChatMessage? {
        var chatMessage = ChatMessage()
        
        return chatMessage
        
    }

}
