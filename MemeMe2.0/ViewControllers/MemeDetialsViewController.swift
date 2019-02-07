//
//  MemeDetialsViewController.swift
//  MemeMe1.0
//
//  Created by khawlah on 12/13/18.
//  Copyright © 2018 khawlah. All rights reserved.
//

import UIKit

class MemeDetialsViewController: UIViewController {


    var image : UIImage? = nil
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        if let image = image {
            imageView.image = image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

}
