//
//  PieChartCollectionViewCell.swift
//  financeApp
//
//  Created by Yves Songolo on 9/3/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import XJYChart

class PieChartCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var shartView: UIView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var monday: UILabel!
    @IBOutlet weak var tuesday: UILabel!
    @IBOutlet weak var wednesday: UILabel!
    @IBOutlet weak var thursday: UILabel!
    @IBOutlet weak var friday: UILabel!
    @IBOutlet weak var saturday: UILabel!
    @IBOutlet weak var sunday: UILabel!
    
    @IBOutlet weak var monColor: UIImageView!
    @IBOutlet weak var tueColor: UIImageView!
    @IBOutlet weak var wedColor: UIImageView!
    @IBOutlet weak var thColor: UIImageView!
    @IBOutlet weak var friColor: UIImageView!
    @IBOutlet weak var satColor: UIImageView!
    @IBOutlet weak var sunColor: UIImageView!
    
    
}
