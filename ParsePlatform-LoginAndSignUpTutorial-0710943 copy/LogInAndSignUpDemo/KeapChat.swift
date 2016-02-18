//
//  KeapChat.swift
//  Keap
//
//  Created by Michael Zuccarino on 2/17/16.
//
//

import UIKit
import SocketIOClientSwift

class KeapChat: NSObject {
    
    static let client = KeapChat()
    
    let socket = SocketIOClient(socketURL: NSURL(string: "http://54.67.94.5:3000")!, options: [.Log(true), .ForcePolling(true)])
    
    override init() {
        
        socket.on("connect") {data, ack in
            print("socket connected")
        }
        
        socket.on("currentAmount") {data, ack in
           
        }
        
        socket.connect()
    }

}
