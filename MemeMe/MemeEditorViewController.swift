//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Moaz on 10/5/15.
//  Copyright © 2015 Moaz Ahmed. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Outlets
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //global variables
    var isViewTransitionedUp = false    //flag to prevent multiple calls for keyboardWillShow notification
    var keyboardHeight: CGFloat = 0.0   //to make sure height transitioned down the same as transitioned up
    
    override func viewDidLoad() {
        
        //set text fields delegates
        topTextField.delegate = self
        bottomTextField.delegate = self
        
        //set textField string attributes
        let textAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSStrokeWidthAttributeName: -3.0,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSForegroundColorAttributeName: UIColor.whiteColor()]

        topTextField.defaultTextAttributes = textAttributes
        topTextField.textAlignment = .Center
        bottomTextField.defaultTextAttributes = textAttributes
        bottomTextField.textAlignment = .Center
        
        //find if camera exits
         cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    override func viewWillAppear(animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(animated: Bool) {
        unsubscribeoKeyboardNotifications()
    }
    
    /******************** keyboard and textFields Behavior *****************/
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {

        //dismiss the keyboard
        textField.resignFirstResponder()
        return false
    }
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.transitionViewUp(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.transitionViewDown(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    func unsubscribeoKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func transitionViewUp(notification: NSNotification) {
        
        //transition view up
        if bottomTextField.isFirstResponder() && !isViewTransitionedUp {
            updateKeyboardHeight(notification)
            self.view.frame.origin.y -= keyboardHeight
            isViewTransitionedUp = true
        }
    }
    func transitionViewDown(notification: NSNotification) {

        //re-transition view to original position
        if isViewTransitionedUp {
            self.view.frame.origin.y += keyboardHeight //getKeyboardHeight(notification)
            isViewTransitionedUp = false
            keyboardHeight = 0.0
        }
    }
    func updateKeyboardHeight(notification: NSNotification) {

        //update global variable keyboardHeight
        var userinfo = notification.userInfo!
        let keyboardSize = (userinfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue().size
        keyboardHeight = keyboardSize.height
    }
    
    /****************** Meme generation and image handling *****************/
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //dismiss image picker view controller
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
            self.imageView.contentMode = .ScaleAspectFit
        }
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        //dismiss picker
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func createMemeImageFromView() -> UIImage {
        
        //hide toolbar and navigation bar
        self.navigationBar.hidden = true
        self.toolBar.hidden = true
        
        // Render on-screen view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //show both bars again
        self.navigationBar.hidden = false
        self.toolBar.hidden = false

        return memedImage
    }
    func saveMeme() -> Meme? {
        
        //create a new meme and return it
        if let originalImage = imageView.image {
            let memedImage = createMemeImageFromView()
            let meme = Meme(bottomText: bottomTextField.text!, topText: topTextField.text!, originalImage: originalImage, memedImage: memedImage)
            return meme
        }
        return nil
    }
    
    
    /******************************* Action Handlers **********************/
    
    @IBAction func shareButton(sender: UIBarButtonItem) {
        
        //save meme object first
        let meme = saveMeme()?.memedImage
        
        
        if let memeImage = meme {
            //create an activity view
            let activityView = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
            activityView.popoverPresentationController?.barButtonItem = sender
            
            //show controller
            self.presentViewController(activityView, animated: true, completion: nil)
        }
    }
    @IBAction func cancelButton(sender: AnyObject) {
        self.imageView.image = nil
    }
    @IBAction func choosePhoto(sender: UIBarButtonItem) {
        
        //choose photo from photo library
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if sender == cameraButton {
            imagePicker.sourceType = .Camera
            
        }else if sender == photoLibraryButton {
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.modalPresentationStyle = .OverCurrentContext  //to enable landscape mode on iPad
        }
        
        //show image choosing interface
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    

}
