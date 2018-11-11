//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by بدور on 09/11/2018.
//  Copyright © 2018 Bdour. All rights reserved.
//

import Foundation
import UIKit

// MARK: - SentMemesCollectionViewController: UICollectionViewController

class SentMemesCollectionViewController : UICollectionViewController {
    
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    // This is an array of memes instances
   var memes: [Meme]! {
       let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
       return appDelegate.memes
  }
  
    // MARK: Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //update collection view
        collectionView!.reloadData()
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       // set flow layout properties.
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
       
        // the space between items within a row or column
        flowLayout.minimumInteritemSpacing = space
         //the space between rows or columns
        flowLayout.minimumLineSpacing = space
        //cell size
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomMemeCell",
                                                      for: indexPath) as! CustomMemeCell
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set image
         cell.imageView?.image = meme.memedImage
        
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.meme = memes[(indexPath as NSIndexPath).row]
        
        // Present the view controller using navigation
          navigationController!.pushViewController(detailController, animated: true)

    }
}
