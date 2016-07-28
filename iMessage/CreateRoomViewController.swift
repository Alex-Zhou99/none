//
//  CreateRoomViewController.swift
//  iMessage
//
//  Created by Edward on 7/23/16.
//  Copyright © 2016 Edward. All rights reserved.
//

import UIKit
import FirebaseAuth
class CreateRoomViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var choosePhotoBtn: UIButton!
    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var captionLbl: UITextField!
    
    var selectedPhoto: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let dismissKeyboard = UITapGestureRecognizer(target: self, action: #selector(CreateRoomViewController.dismissKeyboard(_:)))
        dismissKeyboard.numberOfTapsRequired = 1
        view.addGestureRecognizer(dismissKeyboard)
        // Do any additional setup after loading the view.
    }
    
    func dismissKeyboard(tap: UITapGestureRecognizer){
        view.endEditing(true)
    }
    
    @IBAction func CancelDidTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func selectPhoto_DidTapped(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            imagePicker.sourceType = .Camera
        }else{
            imagePicker.sourceType = .PhotoLibrary
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedPhoto = info[UIImagePickerControllerOriginalImage] as? UIImage
        photoImg.image = selectedPhoto
        picker.dismissViewControllerAnimated(true, completion: nil)
        choosePhotoBtn.hidden = true
    }

    @IBAction func CreateRoomDidTapped(sender: AnyObject) {
        var data: NSData = NSData()
        data = UIImageJPEGRepresentation(photoImg.image!, 0.1)!
        DataService.dataService.CreateNewRoom((FIRAuth.auth()?.currentUser)!, caption: captionLbl.text!, data: data)
        dismissViewControllerAnimated(true, completion: nil)
    }
}
