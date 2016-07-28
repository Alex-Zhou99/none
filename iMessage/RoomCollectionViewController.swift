//
//  RoomCollectionViewController.swift
//  iMessage
//
//  Created by Edward on 7/23/16.
//  Copyright © 2016 Edward. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class RoomCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    
    var rooms = [Room]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.dataService.fetchDataFromServer{ (room) in
            self.rooms.append(room)
            let indexPath = NSIndexPath(forItem: self.rooms.count - 1, inSection: 0)
            self.collectionView?.insertItemsAtIndexPaths([indexPath])
        }

    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return rooms.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("roomCell", forIndexPath: indexPath) as! RoomCollectionViewCell
        let room = rooms[indexPath.row]
        // Configure the cell
        cell.configureCell(room)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.size.width / 2 - 5, view.frame.size.width / 2 - 5)
    }
    
    @IBAction func logout(sender: AnyObject) {
        let actionSheetController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action)
            in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let profileActionButton = UIAlertAction(title: "Profile", style: UIAlertActionStyle.Default){ (action) in
            let profileVC = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfile") as! ProfileTableViewController
            self.navigationController?.pushViewController(profileVC, animated: true)
            
        }
        actionSheetController.addAction(profileActionButton)
        
        let logoutAction = UIAlertAction(title: "Log out", style: UIAlertActionStyle.Default) { (action)
            in
            self.logoutDidTapped()
        }
        actionSheetController.addAction(logoutAction)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    func logoutDidTapped(){
        DataService.dataService.logout()
    }
    
}
