//
//  ChatTableViewCell.swift
//  iMessage
//
//  Created by Edward on 7/28/16.
//  Copyright © 2016 Edward. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import Firebase
class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var messageTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.clipsToBounds = true
    }
    func configCell(message: Dictionary<String, AnyObject>){
        self.messageTextLabel.text = message["message"] as? String
        DataService.dataService.PROPLE_REF.child((FIRAuth.auth()?.currentUser?.uid)!).observeEventType(.Value, withBlock: {
            snapshot -> Void in
            let dict = snapshot.value as! Dictionary<String, AnyObject>
            let imageUrl = dict["profileImage"] as! String
            if imageUrl.hasPrefix("gs://"){
                FIRStorage.storage().referenceForURL(imageUrl).dataWithMaxSize(INT64_MAX, completion: { (data, error) in
                    if let error = error{
                        print("Error downLoading: \(error)")
                        return
                    }
                    self.profileImageView.image = UIImage.init(data: data!)
                })
            }
        })
    }
}
