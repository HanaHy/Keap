//
//  ChatViewController.swift
//  Keap
//
//  Created by Michael Zuccarino on 2/27/16.
//
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var chatTableView:UITableView!
    
    var friend:KeapUser?
    
    var apiBot:KeapAPIBot?
    
    var chatMessages = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatTableView.registerNib(UINib(nibName: "ChatLeftCell", bundle: nil), forCellReuseIdentifier: "chatLeftCell")
        self.chatTableView.registerNib(UINib(nibName: "ChatRightCell", bundle: nil), forCellReuseIdentifier: "chatRightCell")
        
        self.apiBot = KeapAPIBot(delegate: self)
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("chatLeftCell", forIndexPath: indexPath) as! ChatCell
        
        return cell
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }

}
