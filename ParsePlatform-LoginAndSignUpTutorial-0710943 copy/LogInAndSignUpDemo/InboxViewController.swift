//
//  ChatViewController.swift
//  Keap
//
//  Created by Michael Zuccarino on 2/27/16.
//
//

import UIKit

class InboxViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var messageList = NSMutableArray()
    
    var apiBot:KeapAPIBot?
    
    @IBOutlet weak var inboxTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.inboxTableView.registerNib(UINib(nibName: "ChatTabViewCell", bundle: nil), forCellReuseIdentifier: "inboxCell")
        self.apiBot = KeapAPIBot(delegate: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.apiBot?.getMessageHistoryForUser(KeapUser.currentUser().username, withCompletion: { (result, responseDictionary) -> Void in
            print("MESSAGE INBOX: \(responseDictionary)")
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inboxCell", forIndexPath: indexPath) as! InboxViewCell
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    

}
