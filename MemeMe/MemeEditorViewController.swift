//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Moaz on 10/5/15.
//  Copyright © 2015 Moaz Ahmed. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    
    
    override func viewDidLoad() {
        navigationBar.translucent = true
    }
    
    
    /******************************* Action Handlers **********************/
    
    @IBAction func shareButton(sender: UIBarButtonItem) {
    }
    @IBAction func cancelButton(sender: AnyObject) {
    }
    @IBAction func cameraButton(sender: AnyObject) {
    }
    @IBAction func photoAlbumButton(sender: AnyObject) {
    }
    
    

}
