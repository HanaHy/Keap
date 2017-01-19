//
//  KeapChat.swift
//  Keap
//
//  Created by Michael Zuccarino on 2/17/16.
//
//

import UIKit
import SocketIOClientSwift

enum ChatConnectStatus {
    case NotConnected
    case Connecting
    case Connected
    case NewMessage
}

protocol KeapChatClient {
    func receivedChatMessage(data:[String: Any])
    func updateChatClientStatus(status:ChatConnectStatus)
}

class KeapChat: NSObject {
    
    static let client = KeapChat()
    
    var connectionStatus:ChatConnectStatus = .NotConnected
    
    var delegate:KeapChatClient?
    
    let socket = SocketIOClient(socketURL: NSURL(string: "http://52.8.201.8:3000")!, options: [.Log(true), .ForceWebsockets(true)])
    
    override init() {
        
        super.init()
        
        socket.on("connect") {data, ack in
            print("socket connected")
            self.delegate?.updateChatClientStatus(.Connecting)
        }
        
        socket.on("initializeConnect") {data, ack in
            print("data: \(data)")
            self.socket.emit("handshakeauth", ["nochandle":KeapUser.currentUser().username, "fullname":KeapUser.currentUser().fullname])
        }
        
        socket.on("handshakecomplete") {data, ack in
            print("data: \(data)")
            self.delegate?.updateChatClientStatus(.Connected)
        }
        
        socket.on("noclist update") {data, ack in
            print("data: \(data)")
            
        }
        
        socket.on("noc connected") {data, ack in
            print("data: \(data)")
            
        }
        
        // ignore this one
        socket.on("noti history") {data, ack in
            print("data: \(data)")
            
        }
        
        socket.on("chat incoming") {data, ack in
            print("data: \(data)")
            self.delegate?.updateChatClientStatus(.NewMessage)
        }
        
        socket.on("noc typing event") {data, ack in
            print("data: \(data)")
            
        }
        
        socket.on("disconnect") {data, ack in
            print("data: \(data)")
            self.delegate?.updateChatClientStatus(.NotConnected)
        }
        
        
        socket.connect()
    }
    
    func sendMessage(user:String, message:String) {
        socket.emit("chat sent", ["noc":KeapUser.currentUser().username,"target":user,"message":message])
    }
    
}

/*
var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var querystring = require('querystring');

var usersconnected = 0;
var usersList = {};
var userSocketList = {};
var chatHistory = {};
var userTypingList = {};
var notificationHistory = [];

io.on('connection', function(socket){
usersconnected++;
var currentUser = "";
var currentFullname = "";
console.log('unwired user is connected');
socket.emit('initializeConnect', { welcome: 'handshakestart', numUsers: usersconnected });
socket.on('handshakeauth', function(credentialData){
console.log(credentialData['nochandle'] + ' successful handshake');
socket.emit('handshakecomplete', { success: 'success' });
currentUser = credentialData['nochandle'];
currentFullname = credentialData['fullname'];
usersList[credentialData['nochandle']] = {fullname: credentialData['fullname']};
// userSocketList[credentialData['nochandle']] = socket.id;
socket.join(credentialData['nochandle']);
io.sockets.emit('noclist update', { listOfUsers: usersList });
io.sockets.emit('noc connected', { nochandle: credentialData['nochandle'], fullname: credentialData['fullname'] });
socket.emit('noti history', { notiHistory: notificationHistory });
var connectedString = currentFullname.concat(" connected!");
if (notificationHistory.length >= 20)
{
notificationHistory.shift();
}
notificationHistory.push(connectedString);
});
socket.on('disconnect', function(){
usersconnected--;
var disconnectedString = currentFullname.concat(" disconnected!");
if (notificationHistory.length >= 20)
{
notificationHistory.shift();
}
notificationHistory.push(disconnectedString);
delete usersList[currentUser];
// delete userSocketList[currentUser];
io.sockets.emit('noclist update', { listOfUsers: usersList });
console.log('noc disconnected');
});
socket.on('chat sent', function(payloadDict){
var targetData = payloadDict['target'];
console.log(payloadDict['noc'] + ' sent chat to ' + targetData + " >> " + payloadDict['message']);
if (targetData == "everybody")
{
console.log("sending everyone");
io.sockets.emit('chat incoming', payloadDict);
}
else
{
// var sk = userSocketList[targetData];
io.sockets.in(payloadDict['target']).emit('chat incoming', payloadDict);
StoreMessage(payloadDict['target'],payloadDict['noc'],payloadDict['message']);
}
});
socket.on('noc typing active', function(payloadDict){
var targetData = payloadDict['chat'];
console.log(payloadDict['noc'] + ' started typing to ' + targetData);
if (targetData == "everybody")
{
io.sockets.emit('noc typing update start', payloadDict);
}
else
{
// var sk = userSocketList[targetData];
io.sockets.in(payloadDict['target']).emit('noc typing update start', payloadDict);
}
});
socket.on('noc typing event', function(payloadDict){
var targetData = payloadDict['chat'];
console.log(payloadDict['noc'] + ' typing to ' + targetData + ' >> ' + payloadDict['message']);
if (targetData == "everybody")
{
io.sockets.emit('noc typing eventbrc', payloadDict);
}
else
{
// var sk = userSocketList[targetData];
io.sockets.in(targetData).emit('noc typing eventbrc', payloadDict);
}
});
});

*/
