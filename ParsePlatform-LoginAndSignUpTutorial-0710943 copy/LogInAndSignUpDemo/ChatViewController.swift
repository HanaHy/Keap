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
        self.chatTableView.register(UINib(nibName: "ChatLeftCell", bundle: nil), forCellReuseIdentifier: "chatLeftCell")
        self.chatTableView.register(UINib(nibName: "ChatRightCell", bundle: nil), forCellReuseIdentifier: "chatRightCell")
        
        self.apiBot = KeapAPIBot(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatLeftCell", for: indexPath) as! ChatCell
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
