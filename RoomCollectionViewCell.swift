//
//  RoomCollectionViewCell.swift
//  iMessage
//
//  Created by Edward on 7/24/16.
//  Copyright © 2016 Edward. All rights reserved.
//

import UIKit
import FirebaseStorage
class RoomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailPhoto: UIImageView!
    @IBOutlet weak var captionLbl: UILabel!
    
    func configureCell(room: Room){
        self.captionLbl.text = room.caption
        if let imageUrl = room.thumbnail
        {
            if imageUrl.hasPrefix("gs://")
            {
                FIRStorage.storage().referenceForURL(imageUrl).dataWithMaxSize(INT64_MAX, completion:
                    {
                    (data, error) in
                    if let error = error {
                        print("Error downloding : \(error)")
                        return
                    }
                    self.thumbnailPhoto.image = UIImage.init(data: data!)
                })
            }else if let url = NSURL(string: imageUrl), data = NSData(contentsOfURL: url)
            {
                self.thumbnailPhoto.image = UIImage.init(data: data)

            }
            
        }
        
    }
}
