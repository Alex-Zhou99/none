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


    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
