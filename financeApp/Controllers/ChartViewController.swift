//
//  ChartViewController.swift
//  financeApp
//
//  Created by Yves Songolo on 9/3/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import XJYChart
import ScrollableGraphView

class ChartViewController: UIViewController {
   
    @IBOutlet weak var chartTableView: UITableView!
    
   
    
    var transaction = [Transaction](){
        didSet{
             let trans = Transaction.expensesByYear(year: 2018, transaction: transaction)
            expense = trans.compactMap({$0.amount})
            expenseDate = trans.compactMap({$0.date})
            chartTableView.reloadData()
        }
    }
    var expense = [Double]()
    var expenseDate = [String]()
    var section = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        plaidServices.retrieveTransactions { (transaction) in
            if let trans = transaction{
            self.transaction = trans
                
            }
        }
    }
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
extension ChartViewController: UITableViewDelegate, UITableViewDataSource, ScrollableGraphViewDataSource{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.section = indexPath.section
        switch indexPath.section{
        case 0:
        let cell = tableView.dequeueReusableCell(withIdentifier: "pie", for: indexPath) as! ChartTableViewCell
        return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "line", for: indexPath)
            let chart = setUpLinePlot(cell: cell)
            cell.contentView.addSubview(chart)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "multi", for: indexPath) as! ChartTableViewCell
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "pie", for: indexPath) as! ChartTableViewCell
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Compacted Expense by Day"
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
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
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        switch(plot.identifier) {
        case "darkLine":
            return expense[pointIndex]
        case "dot":
             return expense[pointIndex]
        case "multiBlue": return 0
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
       
        return expenseDate[pointIndex]
    }
    
    func numberOfPoints() -> Int {
        switch section{
        case 1:
        return expense.count
        case 2:
            return 0
        default:
            return 0
        }
    }
    
    func setUpLinePlot(cell: UITableViewCell)-> UIView{
        let graphView = ScrollableGraphView(frame: cell.contentView.frame.insetBy(dx: 0, dy: 5), dataSource: self)
        
        let linePlot = LinePlot(identifier: "darkLine") // Identifier should be unique for each plot.
        
        
        
        linePlot.lineWidth = 1
        linePlot.lineColor = UIColor.colorFromHex(hexString: "#777777")
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor.colorFromHex(hexString: "#555555")
        linePlot.fillGradientEndColor = UIColor.colorFromHex(hexString: "#444444")
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let dotPlot = DotPlot(identifier: "darkLineDot") // Add dots as well.
        dotPlot.dataPointSize = 2
        dotPlot.dataPointFillColor = UIColor.white
        
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let referenceLines = ReferenceLines()
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.positionType = .absolute
        
        referenceLines.absolutePositions = [1, 5, 10,15,20,30,40, 50]
        
        referenceLines.includeMinMax = false
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#19385E")//#333333")
        graphView.dataPointSpacing = 80
        
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        
        graphView.rangeMax = 50
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: linePlot)
        graphView.addPlot(plot: dotPlot)
        return graphView
    }
    func doublelinePlot(cell: UITableViewCell) -> UIView{
        // Setup the line plot.
         let graphView = ScrollableGraphView(frame: cell.contentView.frame.insetBy(dx: 0, dy: 5), dataSource: self)
        let blueLinePlot = LinePlot(identifier: "multiBlue")
        
        blueLinePlot.lineWidth = 1
        blueLinePlot.lineColor = UIColor.colorFromHex(hexString: "#16aafc")
        blueLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        blueLinePlot.shouldFill = true
        blueLinePlot.fillType = ScrollableGraphViewFillType.solid
        blueLinePlot.fillColor = UIColor.colorFromHex(hexString: "#16aafc").withAlphaComponent(0.5)
        
        blueLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the second line plot.
        let orangeLinePlot = LinePlot(identifier: "multiOrange")
        
        orangeLinePlot.lineWidth = 1
        orangeLinePlot.lineColor = UIColor.colorFromHex(hexString: "#ff7d78")
        orangeLinePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        orangeLinePlot.shouldFill = true
        orangeLinePlot.fillType = ScrollableGraphViewFillType.solid
        orangeLinePlot.fillColor = UIColor.colorFromHex(hexString: "#ff7d78").withAlphaComponent(0.5)
        
        orangeLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(1)
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        
        graphView.dataPointSpacing = 80
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        
        graphView.shouldRangeAlwaysStartAtZero = true
        
        // Add everything to the graph.
        graphView.addReferenceLines(referenceLines: referenceLines)
        graphView.addPlot(plot: blueLinePlot)
        graphView.addPlot(plot: orangeLinePlot)
        return graphView
    }
}








