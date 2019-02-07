//
//  SentMemeTableViewController.swift
//  MemeMe1.0
//
//  Created by khawlah on 11/30/18.
//  Copyright © 2018 khawlah. All rights reserved.
//

import UIKit
import Foundation

class SentMemeTableViewController: UITableViewController {
    

    var memes: [memeMe]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.reloadData()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
 
        cell.imageCell.image = memes[indexPath.row].memedImage
        cell.labelCell?.text = memes[indexPath.row].topText + ".." + memes[indexPath.row].bottomText
        return cell
    }
    
    // MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! MemeDetialsViewController
        detailController.image = memes[indexPath.row].memedImage
        
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}
