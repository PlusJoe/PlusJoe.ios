//
//  CreatePostStepThreeViewController.swift
//  PlusJoe
//
//  Created by D on 3/27/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

// http://rajiev.com/resize-uiimage-in-swift/
extension UIImage {
    public func resize(size:CGSize, completionHandler:(resizedImage:UIImage, data:NSData)->()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            var newSize:CGSize = size
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageData = UIImageJPEGRepresentation(newImage, 0.5)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(resizedImage: newImage, data:imageData)
            })
        })
    }
}

class CreatePostStepThreeViewController:
    UIViewController,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate
{
    
    @IBOutlet weak var backNavButton: UIBarButtonItem!
    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var pickPhotoFromLibraryButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var imageOne: UIImageView!
    @IBOutlet weak var imageTwo: UIImageView!
    @IBOutlet weak var imageThree: UIImageView!
    @IBOutlet weak var imageFour: UIImageView!
    
    let picker = UIImagePickerController()
    
    @IBAction func backButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        backNavButton.title = "\u{f053}"
        if let font = UIFont(name: "FontAwesome", size: 20) {
            backNavButton.setTitleTextAttributes([NSFontAttributeName: font], forState: UIControlState.Normal)
        }
        
        nextButton.setTitle("next" + "   \u{f054}", forState: UIControlState.Normal)
        takePhotoButton.setTitle("\u{f030}", forState: UIControlState.Normal)
        pickPhotoFromLibraryButton.setTitle( "\u{f1c5}", forState: UIControlState.Normal)
        
        if UNFINISHED_POST?.image1file != nil
            && UNFINISHED_POST?.image2file != nil
            && UNFINISHED_POST?.image3file != nil
            && UNFINISHED_POST?.image4file != nil {
                takePhotoButton.hidden = true
        } else {
            takePhotoButton.hidden = false
        }
        
        
        picker.delegate = self
        
        imageOne.contentMode = .ScaleAspectFill
        imageTwo.contentMode = .ScaleAspectFill
        imageThree.contentMode = .ScaleAspectFill
        imageFour.contentMode = .ScaleAspectFill

    }
    
    @IBAction func shootPhoto(sender: UIBarButtonItem){
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.cameraCaptureMode = .Photo
        presentViewController(picker, animated: true, completion: nil)

    }
    @IBAction func photoFromLibrary(sender: AnyObject) {
        picker.allowsEditing = false //2
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary 
        presentViewController(picker, animated: true, completion: nil)
//        picker.modalPresentationStyle = .Popover
//        presentViewController(picker, animated: true, completion: nil)//4
//        picker.popoverPresentationController?.barButtonItem = sender as! UIBarButtonItem
    }
    
    //MARK: Delegates
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2

        chosenImage.resize(CGSizeMake(500,500)) { (resizedImage, data) -> () in
            let imageFile = PFFile(name:"image.png", data:data)

            if self.imageOne.image == nil {
                self.imageOne.image = resizedImage
                UNFINISHED_POST?.image1file = imageFile
            } else if self.imageTwo.image == nil {
                self.imageTwo.image = resizedImage
                UNFINISHED_POST?.image2file = imageFile
            } else if self.imageThree.image == nil {
                self.imageThree.image = resizedImage
                UNFINISHED_POST?.image3file = imageFile
            } else if self.imageFour.image == nil {
                self.imageFour.image = resizedImage
                UNFINISHED_POST?.image4file = imageFile
            }
            
            UNFINISHED_POST?.saveInBackgroundWithBlock(nil)
            
            if(self.imageOne.image != nil && self.imageTwo.image != nil && self.imageThree.image != nil && self.imageFour.image != nil) {
                self.takePhotoButton.hidden = true
                self.pickPhotoFromLibraryButton.hidden = true
            } else {
                self.takePhotoButton.hidden = false
                self.pickPhotoFromLibraryButton.hidden = false
            }
            self.dismissViewControllerAnimated(true, completion: nil) //5
        }
        
        
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
