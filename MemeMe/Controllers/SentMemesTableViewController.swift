//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by بدور on 09/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate

class SentMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    // This is an array of memes instances
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
     
        // update table
        tableView.reloadData()
    }
    // MARK: Table View Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "CustomMemeTableCell",
                                                      for: indexPath)
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set text
        cell.textLabel?.text = meme.topText! + " ... " + meme.bottomText!
        
       // resize mamed Image and set to image view
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        meme.memedImage?.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        cell.imageView?.image  = newImage
       
  
        
        return cell
    }
    // fixed hieght for row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 100;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)

        
    }
}

