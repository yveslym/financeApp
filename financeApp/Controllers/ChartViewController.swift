//
//  ChartViewController.swift
//  financeApp
//
//  Created by Yves Songolo on 9/3/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import XJYChart

class ChartViewController: UIViewController {
   
    @IBOutlet weak var chartTableView: UITableView!
    @IBOutlet weak var piChartCollectionView: UICollectionView!
    private var pieChartView: XPieChart?
    
    var transaction = [Transaction](){
        didSet{
            chartTableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        plaidServices.retrieveTransactions { (transaction) in
            if let trans = transaction{
            self.transaction = trans
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       
    }
}

// - Mark: table view life cycle
extension ChartViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pie", for: indexPath) as! ChartTableViewCell
        //cell.transaction = transaction
       // piChartCollectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! ChartTableViewCell
        
        if transaction.count > 0{
            cell.transaction = self.transaction
            let allMonth = transaction.compactMap({$0.monthName})
            let months = Set(allMonth)
            let monthArray = Array(months)
            cell.months = monthArray
            
            cell.piChartCollectionView.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}








