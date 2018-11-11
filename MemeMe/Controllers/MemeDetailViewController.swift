//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by بدور on 09/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import UIKit

// MARK: - MemeDetailViewController: UIViewController

class MemeDetailViewController: UIViewController {

    // MARK: Properties
    
    var meme: Meme!
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        // add edit button to exist nevigation bar
        let navBarbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(MemeDetailViewController.EditMeme))
       
        self.navigationItem.rightBarButtonItem  = navBarbutton
        
        // set memed image
        
        imageView.image = meme.memedImage
        
        
        
    }
    

    // edit button action
    
   @objc func EditMeme(){
    
    // present MemeEditorViewController and send meme object
        let Editor  = self.storyboard!.instantiateViewController(withIdentifier: "Editor") as! MemeEditorViewController
        Editor.meme = meme
        present(Editor, animated: true, completion: nil)
        
    }
}
