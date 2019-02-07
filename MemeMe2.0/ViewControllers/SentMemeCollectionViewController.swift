//
//  SentMemeCollectionViewController.swift
//  MemeMe1.0
//
//  Created by khawlah on 11/30/18.
//  Copyright © 2018 khawlah. All rights reserved.
//

import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
   var memes: [memeMe]! {
     let object = UIApplication.shared.delegate
     let appDelegate = object as! AppDelegate
     return appDelegate.memes
    }

  
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    override func viewDidLoad() {
        super.viewDidLoad()
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)

        }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: Collection View Data Source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.imageCell.image = memes[indexPath.row].memedImage
        return cell
    }
    
    // MARK: Collection View Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! MemeDetialsViewController
        detailController.image = memes[indexPath.row].memedImage
        
        self.navigationController!.pushViewController(detailController, animated: true)
    }
 
}
