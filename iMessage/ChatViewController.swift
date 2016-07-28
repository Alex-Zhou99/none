//
//  ChatViewController.swift
//  iMessage
//
//  Created by Edward on 7/23/16.
//  Copyright © 2016 Edward. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

private struct Constants{
    static let cellIdMessageRecieved = "MessageCellYou"
    static let cellIdMessageSent = "MessageCellMe"
}

class ChatViewController: UIViewController {
    
    var roomId: String!

    @IBOutlet weak var chatTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var messages: [FIRDataSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Room Chat"
        DataService.dataService.fetchMessageFromServer(roomId){ (snap) in
            self.messages.append(snap)
            print(self.messages)
            self.tableView.reloadData()
        }
        
    }
    
    @IBAction func SendButtonDidTapped(sender: AnyObject) {
        self.chatTextField.resignFirstResponder()
        if chatTextField != "" {
            if let user = FIRAuth.auth()?.currentUser{
                DataService.dataService.CreateNewMessage(user.uid, roomId: roomId, textMessage: chatTextField.text!)
            }else{
                // no user is signed in
            }
            self.chatTextField.text = nil
        }else{
            print("error: Empty String")
        }
    }
}
extension ChatViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let messageSnapshot = messages[indexPath.row]
        let message = messageSnapshot.value as! Dictionary<String, AnyObject>
        let messageId = message["senderId"] as! String
        print("edward")
        if messageId == DataService.dataService.currentUser?.uid{
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdMessageSent, forIndexPath: indexPath) as! ChatTableViewCell
            cell.configCell(messageId, message: message)
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier(Constants.cellIdMessageRecieved, forIndexPath: indexPath) as! ChatTableViewCell
            cell.configCell(messageId, message: message)
            return cell
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}