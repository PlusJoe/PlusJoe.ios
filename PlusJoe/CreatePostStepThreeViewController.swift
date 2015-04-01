//
//  CreatePostStepThreeViewController.swift
//  PlusJoe
//
//  Created by D on 3/27/15.
//  Copyright (c) 2015 PlusJoe. All rights reserved.
//

import Foundation

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
        let imageData = UIImagePNGRepresentation(chosenImage)
        
        
        let imageFile = PFFile(name:"image.png", data:imageData)
        
        if imageOne.image == nil {
            imageOne.image = chosenImage
            UNFINISHED_POST?.image1file = imageFile
        } else if imageTwo.image == nil {
            imageTwo.image = chosenImage
            UNFINISHED_POST?.image2file = imageFile
        } else if imageThree.image == nil {
            imageThree.image = chosenImage
            UNFINISHED_POST?.image3file = imageFile
        } else if imageFour.image == nil {
            imageFour.image = chosenImage
            UNFINISHED_POST?.image4file = imageFile
        }
        
        UNFINISHED_POST?.saveEventually(nil)
        
        if(imageOne.image != nil && imageTwo.image != nil && imageThree.image != nil && imageFour.image != nil) {
            takePhotoButton.hidden = true
            pickPhotoFromLibraryButton.hidden = true
        } else {
            takePhotoButton.hidden = false
            pickPhotoFromLibraryButton.hidden = false
        }
        
        dismissViewControllerAnimated(true, completion: nil) //5
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
