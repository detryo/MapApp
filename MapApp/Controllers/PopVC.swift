//
//  PopVC.swift
//  MapApp
//
//  Created by Cristian Sedano Arenas on 12/05/2020.
//  Copyright © 2020 Cristian Sedano Arenas. All rights reserved.
//

import UIKit

class PopVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var popImageView: UIImageView!
    
    var passedImage: UIImage!
    
    func initData(forImage image: UIImage) {
        
        self.passedImage = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popImageView.image = passedImage
        addDoubleTap()
    }
    
    func addDoubleTap() {
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(screenWasDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)
    }
    
    @objc func screenWasDoubleTap() {
        
        dismiss(animated: true, completion: nil)
    }
}
