//
//  StatsViewController.swift
//  Temple
//
//  Created by Roman Rosenast on 6/7/19.
//  Copyright © 2019 Roman Rosenast. All rights reserved.
//

import UIKit
import Charts
import Foundation
import Firebase
import FirebaseAuth

class StatsViewController: UIViewController, ChartViewDelegate {

    var pillarData: [Pillar]?
    var dailyChecklist: [Bool]?
    
    
    @IBOutlet weak var modalWindow: UIView!
    @IBOutlet weak var barChart: HorizontalBarChartView!
    @IBOutlet weak var pillarNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalWindow.layer.cornerRadius = 8
        modalWindow.clipsToBounds = true
        
        barChart.noDataText = "Loading..."
        barChart.noDataTextColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        barChart.xAxis.labelTextColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        barChart.xAxis.labelFont = UIFont(name: "Roboto", size: 20)!
        barChart.legend.textColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
//        barChart.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
//        barChart.tintColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
//        barChart.gridBackgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
//        barChart.borderColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        barChart.xAxis.gridColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        barChart.xAxis.axisLineColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        barChart.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
        barChart.rightAxis.enabled = false
        barChart.leftAxis.enabled = false
        barChart.delegate = self
        
        let db = Database.database().reference().child(String(Auth.auth().currentUser!.uid))
        db.child("History").observeSingleEvent(of: .value, with: { (snapshot) in
            let history = snapshot.value as? [String: Any]
            
            var currentDay = history!["CurrentDay"] as! Int
            
            var names = [String]()
            var values = [[Double]]()
            
            while currentDay > 0 {
                let currentDayStr = "Day" + String(currentDay)
                
                let day = history![currentDayStr] as? [String: Any]
                let dayTitle = day!["Date"] as! String
                
                var dayValuesArray = [Double]()
                
                for index in 1...5 {
                    if (day!["P\(index)Completed"] as! String == "True") {
                        dayValuesArray.append(1.0)
                    } else {
                        dayValuesArray.append(0.0)
                    }
                }
                
                names.append(dayTitle)
                values.append(dayValuesArray)
                
                currentDay -= 1
            }
            
            self.setChart(dataPoints: names, values: values)

        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? ViewController
        vc!.pillarData = pillarData
        vc!.dailyChecklist = dailyChecklist
    }
    
    @IBAction func dismiss(_ sender: Any) {
        performSegue(withIdentifier: "hideStatsModal", sender: self)
    }
    
    func setChart(dataPoints: [String], values: [[Double]]) {
        let formatter = BarChartFormatter()
        formatter.setValues(values: dataPoints)
        let xaxis:XAxis = XAxis()
        
        barChart.noDataText = "No data."
        var dataEntries: [BarChartDataEntry] = []
        
        for j in 0..<values.count {
            let dataEntry = BarChartDataEntry(x: Double(j), yValues: values[j], data: dataPoints[j])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: nil)
        
        var myColors = [UIColor]()
            for index in 0...4 {
                myColors.append(pillarData![index].color)
            }
        chartDataSet.colors = myColors
        
        chartDataSet.valueTextColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        let chartData = BarChartData(dataSet: chartDataSet)
        
        xaxis.valueFormatter = formatter
        barChart.xAxis.labelPosition = .bottom
        barChart.xAxis.drawGridLinesEnabled = false
        barChart.xAxis.valueFormatter = xaxis.valueFormatter
        barChart.xAxis.granularityEnabled = true
        barChart.xAxis.granularity = 1.0
        barChart.xAxis.decimals = 0
        barChart.chartDescription?.enabled = false
        barChart.legend.enabled = false
        barChart.rightAxis.enabled = false
        
        barChart.scaleXEnabled = false
        barChart.pinchZoomEnabled = false
        barChart.doubleTapToZoomEnabled = false
        
        barChart.data = chartData
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        
        let pillarIndex = highlight.stackIndex        
        pillarNameLabel.text = pillarData![pillarIndex].title
        pillarNameLabel.textColor = pillarData![pillarIndex].color

    }

}

@objc(BarChartFormatter)
public class BarChartFormatter: NSObject, IAxisValueFormatter {
    var names = [String]()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return names[Int(value)]
    }
    
    public func setValues(values: [String]) {
        self.names = values
    }
}

