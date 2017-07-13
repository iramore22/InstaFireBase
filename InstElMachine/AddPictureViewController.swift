//
//  AddPictureViewController.swift
//  InstElMachine
//
//  Created by infuntis on 12/07/17.
//  Copyright © 2017 gala. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage

class AddPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let ref = Database.database().reference(withPath: "instelmachine")
    let refStorage = Storage.storage().reference(forURL: "gs://instelmachine.appspot.com/")
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var tagsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        
    }
    
    
    @IBAction func postAction(_ sender: Any) {
        guard let textField = tagsTextField,
            let text = textField.text else { return }
        guard !(selectedImage.image?.isEqualToImage(image: #imageLiteral(resourceName: "defaultPhoto")))! else { return }
        
        let key = ref.childByAutoId().key
        let imageRef = refStorage.child("posts").child("\(key).jpg")
        let data = UIImageJPEGRepresentation(self.selectedImage.image!, 0.6)
        let uploadTask = imageRef.putData(data!, metadata: nil) { (metadata, error) in
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            imageRef.downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                if let url = url {
                    let post = Post(imageUrl: url.absoluteString, tags: text)
                    let postRef = self.ref.child(key)
                    postRef.setValue(post.toAnyObject())
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        }
        
        uploadTask.resume()
        tagsTextField.text = ""
        selectedImage.image = #imageLiteral(resourceName: "defaultPhoto")
        tabBarController!.selectedIndex = 0
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let selectedImageFromPhotos = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        selectedImage.image = selectedImageFromPhotos
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        tagsTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
}
