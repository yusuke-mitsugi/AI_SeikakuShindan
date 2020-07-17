//
//  DetailViewController.swift
//  SeikakuShindan
//
//  Created by Yusuke Mitsugi on 2020/07/17.
//  Copyright © 2020 Yusuke Mitsugi. All rights reserved.
//

import UIKit
import Charts

class DetailViewController: DemoBaseViewController, IAxisValueFormatter {
   
    
    
    let activities = ["知的好奇心", "誠実生", "外向性", "協調性", "感情起伏"]
    //ビッグ５のパーセンテージ
    var percentileArray = [Double]()
    //渡ってきた値のナンバー(ボタンのindex)
    var detailNumber = Int()
    
    var ChildNameArray1 = [String]()
    var ChildPercentileArray1 = [Double]()
    var ChildNameArray2 = [String]()
    var ChildPercentileArray2 = [Double]()
    var ChildNameArray3 = [String]()
    var ChildPercentileArray3 = [Double]()
    var ChildNameArray4 = [String]()
    var ChildPercentileArray4 = [Double]()
    var ChildNameArray5 = [String]()
    var ChildPercentileArray5 = [Double]()
    var ChildNameArray6 = [String]()
    var ChildPercentileArray6 = [Double]()
    
    @IBOutlet weak var chartView: RadarChartView!
    
    let marker = RadarMarkerView.viewFromXib()
    var xAxis = XAxis()
    var yAxis = YAxis()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xAxis = chartView.xAxis
        yAxis = chartView.yAxis
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    //ライブラリー
    func createChartView() {
        //網目のスタイル
        chartView.chartDescription?.enabled = true
        chartView.webLineWidth = 1
        chartView.innerWebLineWidth = 1
        chartView.webColor = .black
        chartView.innerWebColor = .green
        chartView.webAlpha = 1
        
        xAxis = XAxis()
        
        chartView.clear()
        xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 12, weight: .bold)
        xAxis.xOffset = 0
        xAxis.yOffset = 0
        xAxis.valueFormatter = self
        xAxis.labelTextColor = .white
        
        yAxis = YAxis()
        yAxis = chartView.yAxis
        yAxis.labelFont = .systemFont(ofSize: 15, weight: .bold)
        yAxis.labelCount = 6
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 80
        yAxis.drawLabelsEnabled = false
        
        yAxis = chartView.yAxis
        
        let l = chartView.legend
        l.horizontalAlignment = .center
        l.verticalAlignment = .top
        l.orientation = .horizontal
        l.drawInside = false
        l.font = .systemFont(ofSize: 15, weight: .bold)
        l.xEntrySpace = 7
        l.yEntrySpace = 5
        l.textColor = .white
        self.updateChartData()
        chartView.animate(xAxisDuration: 1.4, yAxisDuration: 1.4, easingOption: .easeInBack)
        
        updateChartData()
    }
    
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        switch detailNumber {
        case 0:
            return ChildNameArray1[Int(value) % ChildNameArray1.count]
        case 1:
            return ChildNameArray2[Int(value) % ChildNameArray2.count]
        case 2:
            return ChildNameArray3[Int(value) % ChildNameArray3.count]
        case 3:
            return ChildNameArray3[Int(value) % ChildNameArray3.count]
        case 4:
            return ChildNameArray4[Int(value) % ChildNameArray4.count]
        default:
            return ChildNameArray1[Int(value) % ChildNameArray1.count]
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if percentileArray.count != 0 {
            for set in chartView.data!.dataSets {
                set.drawValuesEnabled = !set.drawValuesEnabled
            }
            chartView.setNeedsDisplay()
        }
        if percentileArray.count != 0 {
            self.setChartData()
        }
    }
    
    
    
    
    func setChartData() {
        //データをチャートにセットする
        var entries1 = [ChartDataEntry]()
        //知的好奇心
        if detailNumber == 0 {
            for i in 0..<6 {
                entries1.append(RadarChartDataEntry(value: ChildPercentileArray1[i]*100))
            }
        }
        if detailNumber == 1 {
            for i in 0..<6 {
                entries1.append(RadarChartDataEntry(value: ChildPercentileArray2[i]*100))
            }
        }
        if detailNumber == 2 {
            for i in 0..<6 {
                entries1.append(RadarChartDataEntry(value: ChildPercentileArray3[i]*100))
            }
        }
        if detailNumber == 3 {
            for i in 0..<6 {
                entries1.append(RadarChartDataEntry(value: ChildPercentileArray4[i]*100))
            }
        }
        if detailNumber == 4 {
            for i in 0..<6 {
                entries1.append(RadarChartDataEntry(value: ChildPercentileArray5[i]*100))
            }
        }
        let set1 = RadarChartDataSet(entries: entries1, label: "ビック５のパーソナリティ特性\n\(activities[detailNumber])の詳細")
        set1.setColor(UIColor(red: 103/255,
                              green: 110/255,
                              blue: 129/255,
                              alpha: 1))
        //グラフの色
        set1.fillColor = UIColor(red: 103/255,
                                 green: 110/255,
                                 blue: 129/255,
                                 alpha: 1)
        //塗り潰すかどうか
        set1.drawFilledEnabled = true
        set1.fillAlpha = 0.8
        set1.lineWidth = 10
        set1.drawHighlightCircleEnabled = true
        set1.setDrawHighlightIndicators(false)
        let data = RadarChartData(dataSets: [set1])
        data.setValueFont(.systemFont(ofSize: 20, weight: .bold))
        data.setDrawValues(true)
        data.setValueTextColor(.white)
        chartView.data = data
    }
}
