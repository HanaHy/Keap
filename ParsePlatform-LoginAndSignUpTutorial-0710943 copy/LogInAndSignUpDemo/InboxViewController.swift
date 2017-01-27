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
        self.inboxTableView.register(UINib(nibName: "ChatTabViewCell", bundle: nil), forCellReuseIdentifier: "inboxCell")
        self.apiBot = KeapAPIBot(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.apiBot?.getMessageHistory(forUser: KeapUser.current().username, withCompletion: { (result, responseDictionary) -> Void in
            print("MESSAGE INBOX: \(responseDictionary)")
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inboxCell", for: indexPath) as! InboxViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    

}
