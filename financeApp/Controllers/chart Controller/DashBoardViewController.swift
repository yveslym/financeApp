//
//  DashBoardViewController.swift
//  financeApp
//
//  Created by Yves Songolo on 9/12/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import XJYChart
import AnimatedCollectionViewLayout

class DashBoardViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, XJYChartDelegate {
    
     @IBOutlet weak var piChartCollectionView: UICollectionView!
    
    var transaction = [Transaction](){
        didSet{
            DispatchQueue.main.async {
                let allMonth = self.transaction.compactMap({$0.monthName})
                let months = Set(allMonth)
                let monthArray = Array(months)
                self.months = monthArray
                self.piChartCollectionView.reloadData()
            }
        }
    }
    var months = [String]()
    private var pieChartView: XPieChart?
    var expenses = [String: Double]()
    var mappedColor = [String:UIColor]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
self.retrieveTransaction()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if months.count == 0 {
            return 0
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pie", for: indexPath) as! PieChartCollectionViewCell
        
        let view = getExpenseData(month: months[indexPath.row])
        view.frame = cell.shartView.frame.insetBy(dx: 10, dy: 10)
//        cell.shartView.subviews.forEach({
//            if $0.tag == 100{
//                $0.removeFromSuperview()
//            }
//        })
//
//        view.tag = 100
        cell.shartView.addSubview(view)
//        cell.shartView.addSubview(view)
//        cell.month.text = months[indexPath.row]
//        cell.monday.text = "$ \(expenses[Constant.days[0]] ?? 0)"
//        cell.tuesday.text = "$ \(expenses[Constant.days[1]] ?? 0)"
//        cell.wednesday.text = "$ \(expenses[Constant.days[2]] ?? 0)"
//        cell.thursday.text = "$ \(expenses[Constant.days[3]] ?? 0)"
//        cell.friday.text = "$ \(expenses[Constant.days[4]] ?? 0)"
//        cell.saturday.text = "$ \(expenses[Constant.days[5]] ?? 0)"
//        cell.sunday.text = "$ \(expenses[Constant.days[6]] ?? 0)"
//        cell.monColor.backgroundColor = mappedColor[Constant.days[0]]
//        cell.tueColor.backgroundColor = mappedColor[Constant.days[1]]
//        cell.wedColor.backgroundColor = mappedColor[Constant.days[2]]
//        cell.thColor.backgroundColor = mappedColor[Constant.days[3]]
//        cell.friColor.backgroundColor = mappedColor[Constant.days[4]]
//        cell.satColor.backgroundColor = mappedColor[Constant.days[5]]
//        cell.sunColor.backgroundColor = mappedColor[Constant.days[6]]
        
        
        //cell.frame.size.height = self.frame.height
        return cell
    }
    /// method to get expense data
    func getExpenseData(month: String) -> UIView{
        expenses = [String: Double]()
        Constant.days.forEach { (day) in
            let ex = Transaction.totalExpensesBydayOfWeek(dayKey: day, monthKey: month, transaction: transaction)
            expenses[day] = ex
        }
        return setUpChart(expense: expenses)
    }
    
    func setUpChart(expense:[String:Double]) -> UIView{
        pieChartView = XPieChart()
        var pieItems: [AnyHashable] = []
        let color = [UIColor.babyBlue(),UIColor.banana(),UIColor.antiqueWhite(),UIColor.beige(),UIColor.orchid(),UIColor.grape(), UIColor.brickRed()]
        var index = 0
        for (day,exp) in expense{
            if exp > 10{
                let item = XPieItem(dataNumber: exp as NSNumber, color: color[index], dataDescribe: day)
                mappedColor[day] = color[index]
                index += 1
                pieItems.append(item!)
                
            }
            else{
                let item = XPieItem(dataNumber: exp as NSNumber, color: color[index], dataDescribe: "")
                index += 1
                pieItems.append(item!)
                
                
            }
        }
        
        pieChartView?.dataItemArray = NSMutableArray(array: pieItems)
        pieChartView?.descriptionTextColor = UIColor.black25Percent()
        pieChartView?.delegate = self
        pieChartView?.onlyShowValues = true
        
        
        pieChartView?.frame = CGRect(x: 50, y: 5, width: 300, height: 190)
        //        if let aView = pieChartView {
        //            contentView.addSubview(aView)
        //        }
        return pieChartView!
    }
    func retrieveTransaction(){
        plaidServices.retrieveTransactions { (trans) in
            guard let trans = trans else {return}
            self.transaction = trans
        }
    }
    
}





