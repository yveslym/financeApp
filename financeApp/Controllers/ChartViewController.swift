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
            let incomeTrans = Transaction.incomeByYear(year: 2018, transaction: transaction)
            income = incomeTrans.compactMap({$0.amount})
            expense = trans.compactMap({$0.amount})
            
            expenseDate = trans.compactMap({$0.date})
            chartTableView.reloadData()
        }
    }
    var expense = [Double]()
    var expenseDate = [String]()
    var income = [Double]()
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
        return 4
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "bar", for: indexPath)
           let chart = setupBarChart(cell: cell)
            cell.contentView.addSubview(chart)
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "multi", for: indexPath)
            let chart = setupDoubleLinePlot(cell: cell)
            cell.contentView.addSubview(chart)
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
        case "bar":
            return transaction[pointIndex].amount
        case "multiBlue":
            return income[pointIndex]
        case "multiOrange":
            return expense[pointIndex]
        case "multiBlueDot":
            return income[pointIndex]
        case "multiOrangeSquare":
            return expense[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        switch section{
        case 1:
            return expenseDate[pointIndex]
        case 2:
            return transaction[pointIndex].date!
        case 3:
            return expenseDate[pointIndex]
        default:
            return "0"
        }
    }
    
    func numberOfPoints() -> Int {
        switch section{
        case 1:
            return expense.count
        case 2:
            return transaction.count
        case 3:
            return income.count
        default:
            return 0
        }
    }
    
    func setUpLinePlot(cell: UITableViewCell)-> UIView {
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
   
    func setupBarChart(cell: UITableViewCell) -> UIView{
    
         let graphView = ScrollableGraphView(frame: cell.contentView.frame.insetBy(dx: 0, dy: 5), dataSource: self)
        // Setup the plot
        let barPlot = BarPlot(identifier: "bar")
        
        barPlot.barWidth = 25
        barPlot.barLineWidth = 1
        barPlot.shouldRoundBarCorners = true
        
        barPlot.barLineColor = UIColor.colorFromHex(hexString: "#777777")
        barPlot.barColor = UIColor.colorFromHex(hexString: "#555555")
        
        barPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        barPlot.animationDuration = 1.5
        
        // Setup the reference lines
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        
        referenceLines.dataPointLabelColor = UIColor.white.withAlphaComponent(0.5)
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.colorFromHex(hexString: "#333333")
        
        graphView.shouldAnimateOnStartup = true
        graphView.dataPointSpacing = 60
        graphView.rangeMax = 100
        graphView.rangeMin = 0
        
        // Add everything
        graphView.addPlot(plot: barPlot)
        graphView.addReferenceLines(referenceLines: referenceLines)
        return graphView
    }
    
    func setupDoubleLinePlot(cell: UITableViewCell) -> UIView{
        let graphView = ScrollableGraphView(frame: cell.contentView.frame.insetBy(dx: 0, dy: 5), dataSource: self)

        // Setup the first plot.
        let blueLinePlot = LinePlot(identifier: "multiBlue")
        
        blueLinePlot.lineColor = UIColor.colorFromHex(hexString: "#16aafc")
        blueLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // dots on the line
        let blueDotPlot = DotPlot(identifier: "multiBlueDot")
        blueDotPlot.dataPointType = ScrollableGraphViewDataPointType.circle
        blueDotPlot.dataPointSize = 5
        blueDotPlot.dataPointFillColor = UIColor.colorFromHex(hexString: "#16aafc")
        
        blueDotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the second plot.
        let orangeLinePlot = LinePlot(identifier: "multiOrange")
        
        orangeLinePlot.lineColor = UIColor.colorFromHex(hexString: "#ff7d78")
        orangeLinePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // squares on the line
        let orangeSquarePlot = DotPlot(identifier: "multiOrangeSquare")
        orangeSquarePlot.dataPointType = ScrollableGraphViewDataPointType.square
        orangeSquarePlot.dataPointSize = 5
        orangeSquarePlot.dataPointFillColor = UIColor.colorFromHex(hexString: "#ff7d78")
        
        orangeSquarePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.white.withAlphaComponent(0.2)
        referenceLines.referenceLineLabelColor = UIColor.white
        referenceLines.relativePositions = [0, 0.2, 0.4, 0.6, 0.8, 1]
        
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
        graphView.addPlot(plot: blueDotPlot)
        graphView.addPlot(plot: orangeLinePlot)
        graphView.addPlot(plot: orangeSquarePlot)
        return graphView
    }
}








