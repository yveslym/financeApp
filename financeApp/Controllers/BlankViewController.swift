//
//  BlankViewController.swift
//  financeApp
//
//  Created by Yves Songolo on 9/12/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import SpriteKit
import SnapKit

class BlankViewController: UIViewController {
    var imageView : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let image = UIImage(named: "logo")
        let screenSize: CGRect = UIScreen.main.bounds
        let blank = UIView(frame: screenSize)
        blank.backgroundColor = UIColor.white
        
        imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
       imageView.frame = screenSize
        blank.addSubview(imageView)
        imageView.center = blank.center
        
        self.view.addSubview(blank)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
