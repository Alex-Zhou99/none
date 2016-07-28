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
    
    private var _MESSAGE_REF = roofRef.child("messages")
    
    private var _PROPLE_REF = roofRef.child("people")
    
    var currentUser: FIRUser? {
        return FIRAuth.auth()!.currentUser!
    }
    
    var ROOM_REF: FIRDatabaseReference{
        return _ROOM_REF
    }
    
    var PROPLE_REF: FIRDatabaseReference{
        return _PROPLE_REF
    }
    
    var MESSAGE_REF: FIRDatabaseReference{
        return _MESSAGE_REF
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
                idRoom.setValue(["caption": caption, "thumbaniUrlFromStorage": self.storageRef.child(metadata!.path!).description, "fileUrl": self.fileUrl])
            }
        }
    }
    
    /*func fetchDataFromServer(callback: (Room)->()){
        DataService.dataService.ROOM_REF.observeEventType(.ChildAdded, withBlock: { ( snapshot) in
            let room = Room(key: snapshot.key, snapshot: snapshot.value as! Dictionary<String, AnyObject>)
            //Gets the key of the location that generated this DataSnapshot
            callback(room)
        })
    }*/
    
    
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
                self.PROPLE_REF.child((user?.uid)!).setValue(["username": username, "email": email, "profileImage": self.storageRef.child((metadata?.path)!).description])
                ProgressHUD.showSuccess("Succeeded")
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.login()
            })
            
        
        })
    }
    func login(email: String, password: String){
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            ProgressHUD.showSuccess("Succeeded")
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.login()
        })
        
    }
    
    func logout(){
        let firebaseAuth = FIRAuth.auth()
        do{
            try firebaseAuth?.signOut()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let logInVC = storyboard.instantiateViewControllerWithIdentifier("LogInVC")
            UIApplication.sharedApplication().keyWindow?.rootViewController = logInVC
        }catch let signOutError as NSError{
            print("Error signing out : \(signOutError)")
        }
    }
    func saveProfile(username: String, email: String, data: NSData){
        let user = FIRAuth.auth()?.currentUser!
        let filePath = "\(user!.uid)/\(Int(NSDate.timeIntervalSinceReferenceDate()))"
        let metaData = FIRStorageMetadata()
        metaData.contentType = "image/jpg"
        self.storageRef.child(filePath).putData(data, metadata: metaData) { (metadata, error) in
            if let error = error{
                print("Error uploading: \(error.description)")
                return
            }
            self.fileUrl = metadata!.downloadURLs![0].absoluteString
            let changeRequestProfile = user?.profileChangeRequest()
            changeRequestProfile?.photoURL = NSURL(string: self.fileUrl)
            changeRequestProfile?.displayName = username
            changeRequestProfile?.commitChangesWithCompletion({ ( error) in
                if let error = error {
                    print(error.localizedDescription)
                    ProgressHUD.showError("Network error")
                }else{
                    
                }
            })
            if let user = user{
                user.updateEmail(email, completion: { (error) in
                    if let error = error {
                        print(error.description)
                    }else{
                        print("email update")
                    }
                })
            }
            ProgressHUD.showSuccess("Saved")
        }
    }
    func CreateNewMessage(userId: String, roomId: String, textMessage: String){
        let idMessage = roofRef.child("messages").childByAutoId()
        DataService.dataService.MESSAGE_REF.child(idMessage.key).setValue(["message": textMessage, "senderId": userId])
        DataService.dataService.ROOM_REF.child(roomId).child("messages").child(idMessage.key).setValue(true)
        
    }
    func fetchMessageFromServer(roomId: String, callback:(FIRDataSnapshot) -> ()) {
        DataService.dataService.ROOM_REF.child(roomId).child("messages").observeEventType(.ChildAdded, withBlock: { snapshot -> Void in
            DataService.dataService.MESSAGE_REF.child(snapshot.key).observeEventType(.Value, withBlock: {
                snap -> Void in
                callback(snap)
            })
        })
    }
}