//
//  PostViewController.swift
//  OOTD-app
//
//  Created by Dana Kirsanov on 12/10/16.
//  Copyright © 2016 nyu.edu. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var previewImageView: UIImageView!
    
    
    @IBOutlet weak var selectImageButton: UIButton!
    
    
    
    var imageFileNAme = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addTapped(_ sender: Any) {
        
        //ensure there's a value in the fields
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            if let title = titleTextField.text {
                if let content = contentTextView.text {
                    let postObject: Dictionary<String, Any> = [
                        "uid" : uid,
                        "title" : title,
                        "content" : content,
                        "image" : imageFileNAme
                    ]
                    
                    FIRDatabase.database().reference().child("posts").childByAutoId().setValue(postObject)
                    
                    print("Posted to Firebase.")
                    
                    
                }
            }
        }

    }
    
    
    @IBAction func selectImageTapped(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func uploadImage(image: UIImage){
        let randomName = randomString(length:10)
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let uploadRef = FIRStorage.storage().reference().child("images/\(randomName).jpg")
        
        let uploadTask = uploadRef.put(imageData!, metadata: nil) { metadata, error in
            if error == nil {
                //success
                print("uploaded image")
                self.imageFileNAme = "\(randomName as String).jpg"
                
            } else {
                //error
                print(error?.localizedDescription)
            }
            
        }
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        //var randomString: NSMutableString = NSMutableString(capacity: length)
        var randomString = ""
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //if user hits cancel
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //will run when user finishes picking image
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.previewImageView.image = pickedImage
            //self.selectImageButton.isEnabled = false
            self.selectImageButton.isHidden = true
            uploadImage(image: pickedImage)
            picker.dismiss(animated: true, completion: nil)
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
