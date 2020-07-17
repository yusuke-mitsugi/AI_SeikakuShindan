//
//  ViewController.swift
//  SeikakuShindan
//
//  Created by Yusuke Mitsugi on 2020/07/17.
//  Copyright © 2020 Yusuke Mitsugi. All rights reserved.
//

import UIKit
import PersonalityInsights
import CircleMenu
import Charts
import Lottie

class ViewController: DemoBaseViewController, CircleMenuDelegate, PasteDelegate {
   
    
    
    //Watson APIキー
   // K6oLnAQoz2V7plYtWDwIY5GlrpN8oyxZRVONQVgKw8P9
    @IBOutlet weak var chartView: RadarChartView!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var shindanButton: UIButton!
    
    var animationView: AnimationView = AnimationView()
    let activities = ["知的好奇心", "誠実生", "外向性", "協調性", "感情起伏"]
    var nameArray = [String]()
    //ビッグ５のパーセンテージ
    var percentileArray = [Double]()
    
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
    
    var consumption_preferences_NameArray1 = [String]()
    var consumption_preferences_ScoreArray1 = [Double]()
    var consumption_preferences_NameArray2 = [String]()
    var consumption_preferences_ScoreArray2 = [Double]()
    var consumption_preferences_NameArray3 = [String]()
    var consumption_preferences_ScoreArray3 = [Double]()
    var consumption_preferences_NameArray4 = [String]()
    var consumption_preferences_ScoreArray4 = [Double]()
    var consumption_preferences_NameArray5 = [String]()
    var consumption_preferences_ScoreArray5 = [Double]()
    var consumption_preferences_NameArray6 = [String]()
    var consumption_preferences_ScoreArray6 = [Double]()
    var consumption_preferences_NameArray7 = [String]()
    var consumption_preferences_ScoreArray7 = [Double]()
    var consumption_preferences_NameArray8 = [String]()
    var consumption_preferences_ScoreArray8 = [Double]()
    
    //ボタンを押された時の色
    let items: [(icon: String, color: UIColor)] = [
        ("1", UIColor(red: 0.19, green: 0.57, blue: 1, alpha: 1)),
        ("2", UIColor(red: 0.22, green: 0.74, blue: 0, alpha: 1)),
        ("3", UIColor(red: 0.96, green: 0.23, blue: 0.21, alpha: 1)),
        ("4", UIColor(red: 0.51, green: 0.15, blue: 1, alpha: 1)),
        ("5", UIColor(red: 1, green: 0.39, blue: 0, alpha: 1))
    ]
    
    //リセットボタンが押されたかどうか
    var resetFlag = false
    //分析ボタンを押した後の、２回目かどうか
    var restartFlag = false
    //サークルボタン
    let button = CircleMenu(frame: CGRect(x: 175, y: 684, width: 64, height: 64),
                            normalIcon: "openMenu",
                            selectedIcon: "close",
                            buttonsCount: 5,
                            duration: 0.2,
                            distance: 120)
    let marker = RadarMarkerView.viewFromXib()
    var xAxis = XAxis()
    var yAxis = YAxis()
    
    //一時保管用の配列(name)
    var resultN1 = [String]()
    var resultN2 = [String]()
    var resultN3 = [String]()
    var resultN4 = [String]()
    var resultN5 = [String]()
    var resultN6 = [String]()
    var resultN7 = [String]()
    var resultN8 = [String]()
    //一時保管用の配列(score)
    var resultS1 = [Double]()
    var resultS2 = [Double]()
    var resultS3 = [Double]()
    var resultS4 = [Double]()
    var resultS5 = [Double]()
    var resultS6 = [Double]()
    var resultS7 = [Double]()
    var resultS8 = [Double]()
    
    var resultNameArray = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shindanButton.isEnabled = false
        profileButton.isEnabled = false
        button.isEnabled = false
        resetFlag = false
        resetButton.isEnabled = false
        chartView.delegate = self
        textView.text = ""
        
        // Do any additional setup after loading the view.
    }
    
    
    

    @IBAction func analyze(_ sender: Any) {
        if percentileArray.count != 0 && UIPasteboard.general.string?.isEmpty == false && resetFlag != false {
            for set in chartView.data!.dataSets {
                set.drawValuesEnabled = !set.drawValuesEnabled
            }
            chartView.setNeedsDisplay()
        }
        searchButton.isEnabled = false
        shindanButton.isEnabled = false
        profileButton.isEnabled = true
        button.isEnabled = false
        resetButton.isEnabled = true
        //アニメーションスタート
        startAnimation()
        //配列の中身を消去
        removeArray()
        //Watsonのドキュメント通りだとうまくいかない
        let content = ProfileContent.text(textView.text)
        let authenticator = WatsonIAMAuthenticator(apiKey: "K6oLnAQoz2V7plYtWDwIY5GlrpN8oyxZRVONQVgKw8P9")
        let personalityInsights = PersonalityInsights(version: "2020-07-17", authenticator: authenticator)
        
        personalityInsights.profile(profileContent: content,
                                    contentLanguage: "ja",
                                    acceptLanguage: "ja",
                                    rawScores: true,
                                    consumptionPreferences: true,
                                    headers: nil) { (response, error) in
                                        if let error = error {
                                            print(error)
                                        }
                                        guard let profile = response?.result else {
                                            print("なにか起きている")
                                            return
                                        }
                                        for i in 0..<5 {
                                            self.percentileArray.append(profile.personality[i].percentile)
                                        }
                                        for i in 0..<6 {
                                            self.ChildNameArray1.append(profile.personality[0].children![i].name)
                                            self.ChildPercentileArray1.append(profile.personality[0].children![i].percentile)
                                            self.ChildNameArray2.append(profile.personality[1].children![i].name)
                                            self.ChildPercentileArray2.append(profile.personality[1].children![i].percentile)
                                            self.ChildNameArray3.append(profile.personality[2].children![i].name)
                                            self.ChildPercentileArray3.append(profile.personality[2].children![i].percentile)
                                            self.ChildNameArray4.append(profile.personality[3].children![i].name)
                                            self.ChildPercentileArray4.append(profile.personality[3].children![i].percentile)
                                            self.ChildNameArray5.append(profile.personality[4].children![i].name)
                                            self.ChildPercentileArray5.append(profile.personality[4].children![i].percentile)
                                            self.ChildNameArray6.append(profile.personality[5].children![i].name)
                                            self.ChildPercentileArray6.append(profile.personality[5].children![i].percentile)
                                        }
                                        //購入傾向
                                        for i in 0..<12 {
                                            self.consumption_preferences_NameArray1.append(profile.consumptionPreferences![0].consumptionPreferences[i].name)
                                            self.consumption_preferences_ScoreArray1.append(profile.consumptionPreferences![0].consumptionPreferences[i].score)
                                        }
                                        //健康志向
                                        for i in 0..<3 {
                                            self.consumption_preferences_NameArray2.append(profile.consumptionPreferences![1].consumptionPreferences[i].name)
                                            self.consumption_preferences_ScoreArray2.append(profile.consumptionPreferences![1].consumptionPreferences[i].score)
                                        }
                                        //環境懸念傾向
                                        for i in 0..<1 {
                                            self.consumption_preferences_NameArray3.append(profile.consumptionPreferences![2].consumptionPreferences[i].name)
                                            self.consumption_preferences_ScoreArray3.append(profile.consumptionPreferences![2].consumptionPreferences[i].score)
                                        }
                                        for i in 0..<1 {
                                            self.consumption_preferences_NameArray4.append(profile.consumptionPreferences![3].consumptionPreferences[i].name)
                                            self.consumption_preferences_ScoreArray4.append(profile.consumptionPreferences![3].consumptionPreferences[i].score)
                                        }
                                        //映画の好み
                                        for i in 0..<10 {
                                            self.consumption_preferences_NameArray5.append(profile.consumptionPreferences![4].consumptionPreferences[i].name)
                                            self.consumption_preferences_ScoreArray5.append(profile.consumptionPreferences![4].consumptionPreferences[i].score)
                                        }
                                        //音楽の好み
                                        for i in 0..<9 {
                                            self.consumption_preferences_NameArray6.append(profile.consumptionPreferences![5].consumptionPreferences[i].name)
                                            self.consumption_preferences_ScoreArray6.append(profile.consumptionPreferences![5].consumptionPreferences[i].score)
                                        }
                                        for i in 0..<5 {
                                            self.consumption_preferences_NameArray7.append(profile.consumptionPreferences![6].consumptionPreferences[i].name)
                                            self.consumption_preferences_ScoreArray7.append(profile.consumptionPreferences![6].consumptionPreferences[i].score)
                                        }
                                        //ボランティア精神
                                        for i in 0..<1 {
                                            self.consumption_preferences_NameArray8.append(profile.consumptionPreferences![7].consumptionPreferences[i].name)
                                            self.consumption_preferences_ScoreArray8.append(profile.consumptionPreferences![7].consumptionPreferences[i].score)
                                        }
                                        //分析
                                        self.analyzePersonalData()
                                        //チャートをアップデート
                                        DispatchQueue.main.async {
                                            if self.percentileArray.count != 0 {
                                                self.updateChartData()
                                            }
                                        }
        }
    }
    
    //臨時の配列に入れる
    func analyzePersonalData() {
        resultN1 = consumption_preferences_NameArray1
        resultN2 = consumption_preferences_NameArray2
        resultN3 = consumption_preferences_NameArray3
        resultN4 = consumption_preferences_NameArray4
        //        resultN5 = consumption_preferences_NameArray5
        resultN6 = consumption_preferences_NameArray6
        //        resultN7 = consumption_preferences_NameArray7
        resultN8 = consumption_preferences_NameArray8
        
        resultS1 = consumption_preferences_ScoreArray1
        resultS2 = consumption_preferences_ScoreArray2
        resultS3 = consumption_preferences_ScoreArray3
        resultS4 = consumption_preferences_ScoreArray4
        //        resultS5 = consumption_preferences_ScoreArray5
        resultS6 = consumption_preferences_ScoreArray6
        //        resultS7 = consumption_preferences_ScoreArray7
        resultS8 = consumption_preferences_ScoreArray8
        
        //０かどうかの分岐
        for i in 0..<resultS1.count {
            if resultS1[i] == 0.0 {
                //消去
                consumption_preferences_NameArray1.remove(at: i)
                consumption_preferences_ScoreArray1.remove(at: i)
            }
            else {
                resultNameArray.append(resultN1[i])
            }
        }
        for i in 0..<resultS2.count {
            if resultS2[i] == 0.0 {
                //消去
                consumption_preferences_NameArray2.remove(at: i)
                consumption_preferences_ScoreArray2.remove(at: i)
            }
            else {
                resultNameArray.append(resultN2[i])
            }
        }
        for i in 0..<resultS3.count {
            if resultS3[i] == 0.0 {
                //消去
                consumption_preferences_NameArray3.remove(at: i)
                consumption_preferences_ScoreArray3.remove(at: i)
            }
            else {
                resultNameArray.append(resultN3[i])
            }
        }
        for i in 0..<resultS4.count {
            if resultS4[i] == 0.0 {
                //消去
                consumption_preferences_NameArray4.remove(at: i)
                consumption_preferences_ScoreArray4.remove(at: i)
            }
            else {
                resultNameArray.append(resultN4[i])
            }
        }
//        for i in 0..<resultS5.count {
//            if resultS5[i] == 0.0 {
//                //消去
//                consumption_preferences_NameArray5.remove(at: i)
//                consumption_preferences_ScoreArray5.remove(at: i)
//            }
//            else {
//                resultNameArray.append(resultN5[i])
//            }
//        }
        for i in 0..<resultS6.count {
            if resultS6[i] == 0.0 {
                //消去
                consumption_preferences_NameArray6.remove(at: i)
                consumption_preferences_ScoreArray6.remove(at: i)
            }
            else {
                resultNameArray.append(resultN6[i])
            }
        }
//        for i in 0..<resultS7.count {
//            if resultS7[i] == 0.0 {
//                //消去
//                consumption_preferences_NameArray7.remove(at: i)
//                consumption_preferences_ScoreArray7.remove(at: i)
//            }
//            else {
//                resultNameArray.append(resultN7[i])
//            }
//        }
        for i in 0..<resultS8.count {
            if resultS8[i] == 0.0 {
                //消去
                consumption_preferences_NameArray8.remove(at: i)
                consumption_preferences_ScoreArray8.remove(at: i)
            }
            else {
                resultNameArray.append(resultN8[i])
            }
        }
    }
    
    
    
    
    func startAnimation() {
        createChartView()
        let animation = Animation.named("analyze")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: view.frame.size.width,
                                     height: view.frame.size.height)
        animationView.loopMode = .playOnce
        animationView.backgroundColor = .white
        view.addSubview(animationView)
        animationView.play()
        button.isEnabled = true
    }
    
    
    
    
    //ライブラリー
    func createChartView() {
        chartView = RadarChartView()
        chartView.delegate = self
        chartView.removeFromSuperview()
        chartView.frame = CGRect(x: -43,
                                 y: 5,
                                 width: 500,
                                 height: 500)
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
        yAxis.labelCount = 5
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
        view.addSubview(chartView)
//        updateChartData()
    }
    
    
    
    
    //分析した後の配列を消去。ビッグ５
    func removeArray() {
        ChildNameArray1.removeAll()
        ChildPercentileArray1.removeAll()
        ChildNameArray2.removeAll()
        ChildPercentileArray2.removeAll()
        ChildNameArray3.removeAll()
        ChildPercentileArray3.removeAll()
        ChildNameArray4.removeAll()
        ChildPercentileArray4.removeAll()
        ChildNameArray5.removeAll()
        ChildPercentileArray5.removeAll()
        ChildNameArray6.removeAll()
        ChildPercentileArray6.removeAll()
        
        consumption_preferences_NameArray1.removeAll()
        consumption_preferences_ScoreArray1.removeAll()
        consumption_preferences_NameArray2.removeAll()
        consumption_preferences_ScoreArray2.removeAll()
        consumption_preferences_NameArray3.removeAll()
        consumption_preferences_ScoreArray3.removeAll()
        consumption_preferences_NameArray4.removeAll()
        consumption_preferences_ScoreArray4.removeAll()
//        consumption_preferences_NameArray5.removeAll()
//        consumption_preferences_ScoreArray5.removeAll()
        consumption_preferences_NameArray6.removeAll()
        consumption_preferences_ScoreArray6.removeAll()
//        consumption_preferences_NameArray7.removeAll()
//        consumption_preferences_ScoreArray7.removeAll()
        consumption_preferences_NameArray8.removeAll()
        consumption_preferences_ScoreArray8.removeAll()
    }
    
    
    func createCircleButton() {
        button.delegate = self
        button.layer.cornerRadius = button.frame.size.width/2.0
        view.addSubview(button)
    }
    
    
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
            //ビック５のデータが入ってる場合
        else if percentileArray.count != 0 {
            self.setChartData()
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createCircleButton()
    }
    
    
    
    //viewが表示された時
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        self.resetButton.frame.origin.x = self.view.frame.size.width-self.resetButton.frame.size.width-30
                        self.searchButton.frame.origin.x = self.view.frame.size.width-self.searchButton.frame.size.width-30
                        self.profileButton.frame.origin.x = 30
                        self.shindanButton.frame.origin.x = 30
        }) { (finished: Bool) in
            //アニメーション終了に伴う処理
        }
    }
    
    
    
    //viewが消えた時
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveLinear],
                       animations: {
                        self.resetButton.frame.origin.x = self.view.frame.size.width
                        self.searchButton.frame.origin.x = self.view.frame.size.width
                        self.profileButton.frame.origin.x = -64
                        self.shindanButton.frame.origin.x = -64
        }) { (finished: Bool) in
            //アニメーション終了に伴う処理
        }
    }
    
    
    
    
    func setChartData() {
        //アニメーションを閉じる
        let dispatchTime = DispatchTime.now()+1.5
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.animationView.removeFromSuperview()
        }
        //データをチャートにセットする
        var entries1 = [ChartDataEntry]()
        //5つ要素があるので、５回for文を回す
        for i in 0..<5 {
            entries1.append(RadarChartDataEntry(value: percentileArray[i]*100))
        }
        let set1 = RadarChartDataSet(entries: entries1, label: "ビック５のパーソナリティ特性")
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
    
    
    //ドキュメント通り
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
        let highlightImage = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    
    
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        //detailVCへ値を持ったまま渡す
        let detailVC = self.storyboard?.instantiateViewController(identifier: "detail") as! DetailViewController
        detailVC.detailNumber = atIndex
        switch atIndex {
        case 0:
            detailVC.ChildNameArray1 = ChildNameArray1
            detailVC.ChildPercentileArray1 = ChildPercentileArray1
            break
        case 1:
            detailVC.ChildNameArray2 = ChildNameArray2
            detailVC.ChildPercentileArray2 = ChildPercentileArray2
            break
        case 2:
            detailVC.ChildNameArray3 = ChildNameArray3
            detailVC.ChildPercentileArray3 = ChildPercentileArray3
            break
        case 3:
            detailVC.ChildNameArray4 = ChildNameArray4
            detailVC.ChildPercentileArray4 = ChildPercentileArray4
            break
        case 4:
            detailVC.ChildNameArray5 = ChildNameArray5
            detailVC.ChildPercentileArray5 = ChildPercentileArray5
            break
        default:
            detailVC.ChildNameArray1 = ChildNameArray1
            break
        }
        detailVC.percentileArray = percentileArray
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    
    
    
    
    
    func next() {
        UIPasteboard.general.string = ""
        performSegue(withIdentifier: "webView", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC = segue.destination as! WebViewController
        webVC.pasteDelegate = self
    }
    
    
    func addText(copyedText: String) {
        if shindanButton.isEnabled != false && UIPasteboard.general.string?.isEmpty == true {
            removeArray()
            textView.text = ""
            UIPasteboard.general.string = ""
            resetButton.isEnabled = true
            profileButton.isEnabled = true
        }
        else if restartFlag == false || UIPasteboard.general.string?.isEmpty == false {
            shindanButton.isEnabled = true
            profileButton.isEnabled = false
            resetButton.isEnabled = false
            resetFlag = false
            textView.text = ""
            textView.text = UIPasteboard.general.string!
        }
    }
    
    func resetAll() {
        removeArray()
        searchButton.isEnabled = true
        resetFlag = true
        restartFlag = true
        shindanButton.isEnabled = false
        profileButton.isEnabled = false
        button.isEnabled = false
        resetButton.isEnabled = false
        textView.text = ""
        chartView.data = nil
        UIPasteboard.general.string = ""
        percentileArray.removeAll()
    }
    
    @IBAction func reset(_ sender: Any) {
        resetAll()
    }
    
    @IBAction func search(_ sender: Any) {
        next()
    }
    
    @IBAction func topPersonal(_ sender: Any) {
        let personalVC = storyboard?.instantiateViewController(identifier: "personalData") as! Personality_TrendsViewController
        personalVC.resultArray = resultNameArray
        navigationController?.pushViewController(personalVC, animated: true)
    }
    
}

//値をグラフに渡す
extension ViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return activities[Int(value) % activities.count]
    }
}
