//
//  SignUpViewController.swift
//  iMessage
//
//  Created by Edward on 7/23/16.
//  Copyright © 2016 Edward. All rights reserved.
//

import UIKit

//UIImagePickerControllerDelegate这个事件委托来实现照相以及进入照片库
class SignUpViewController: UIViewController{

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    var selectedPhoto: UIImage!
    
    //UIImagePickerController静态方法判断设备是否支持照相机／图片库／相册功能
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.selectPhoto(_:)))
        //设置当前需要触发事件的手指数量
        tap.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tap)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 2
        profileImage.clipsToBounds = true
        
        
    }

    //UITapGestureRecognizer 给图片添加点击事件
    func selectPhoto(tap: UITapGestureRecognizer){
        //设置UIImagePickerController的代理
        self.imagePicker.delegate = self
        //设置当拍照完或在相册选完照片后，是否跳到编辑模式进行图片剪裁。只有当showsCameraControls属性为true时才有效果
        self.imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.Camera){
            //指定使用照相机模式,可以指定使用相册／照片库
            self.imagePicker.sourceType = .Camera
        }else{
            self.imagePicker.sourceType = .PhotoLibrary
        }
        //切换视图并携带切换时的动画
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func SignUpTapped(sender: AnyObject) {
        
        guard let email = emailTextFeild.text where !email.isEmpty, let password = passwordTextField.text where !password.isEmpty, let username = usernameTextField.text where !username.isEmpty else{
            return
        }
        //数据,当我们需要把一些信息写入到文件里或发送到网络上
        var data = NSData()
        //压缩比例计算
        data =  UIImageJPEGRepresentation(profileImage.image!, 0.1)!
        //Signing up
        DataService.dataService.SignUp(username, email: email, password: password, data: data)
        
        
    }
    
    @IBAction func CancelDidTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        selectedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        self.profileImage.image = selectedPhoto
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}