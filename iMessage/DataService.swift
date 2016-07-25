//
//  DataService.swift
//  iMessage
//
//  Created by Edward on 7/24/16.
//  Copyright © 2016 Edward. All rights reserved.
//

import Foundation
import Firebase

let roofRef = FIRDatabase.database().reference()

class DataService{
    
    static let dataService = DataService()
    
    private var _BASE_REF = roofRef
    
    private var _ROOM_REF = roofRef.child("rooms")
    
    var ROOM_REF: FIRDatabaseReference{
        return _ROOM_REF
    }
    
    var BASE_REF: FIRDatabaseReference{
        return _BASE_REF
    }
    var storageRef: FIRStorageReference{
        return FIRStorage.storage().reference()
    }
    var fileUrl: String!
    
    func CreateNewRoom(user: FIRUser, caption: String, data: NSData)
    {
        
        //返回以2001/01/01 GMT为基准，然后过了secs秒的时间
        let filePath = "\(user.uid)/\(Int(NSDate.timeIntervalSinceReferenceDate()))"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.child(filePath).putData(data, metadata: metaData) { (metadata, error) in
            if let error = error{
                print("Error uploading:\(error.description)")
                return
            }
            
            //Create a url for data(thumbnail image)
            self.fileUrl = metadata?.downloadURLs![0].absoluteString
            if let user = FIRAuth.auth()?.currentUser{
                let idRoom = self.BASE_REF.child("rooms").childByAutoId()
                print("fdsafdas")
                idRoom.setValue(["caption": caption, "thumbaniUrlFromStorage": self.storageRef.child(metadata!.path!).description, "fileUrl": self.fileUrl])
            }
        }
    }
    
    func fetchDataFromServer(callback: (Room)->()){
        DataService.dataService.ROOM_REF.observeEventType(.ChildAdded, withBlock: { ( snapshot) in
            //明天看这里，snapshot在firebase中的定义，弄懂，与Room中的结合
            let room = Room(key: snapshot.key, snapshot: snapshot.value as! Dictionary<String, AnyObject>)
            callback(room)
        })
    }
    
    
    //操作文件数据 NSData
    func SignUp(username: String, email: String, password: String, data: NSData)
    {
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { ( user,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            let changeRequest = user?.profileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChangesWithCompletion({ (error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }
            })
            let filePath = "profileImage/\(user?.uid)"
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            self.storageRef.child(filePath).putData(data,metadata: metadata, completion: { ( metadata, error) in
                if let error = error{
                    print("\(error.description)")
                    return
                }
                self.fileUrl = metadata?.downloadURLs![0].absoluteString
                let changeRequestPhoto = user!.profileChangeRequest()
                changeRequestPhoto.photoURL = NSURL(string: self.fileUrl)
                changeRequestPhoto.commitChangesWithCompletion({ (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }else{
                        print("profile updated")
                    }
                })
                ProgressHUD.showSuccess("Succeeded")
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
            })
            
        
        })
    }
    
}