//
//  RadarMarkerView.swift
//  WatsonApp
//
//  Created by Fujii Yuta on 2020/01/24.
//  Copyright © 2020 Fujii Yuta. All rights reserved.
//


import Foundation
import Charts
#if canImport(UIKit)
    import UIKit
#endif

public class RadarMarkerView: MarkerView {
    @IBOutlet var label: UILabel!
    
    public override func awakeFromNib() {
        self.offset.x = -self.frame.size.width / 2.0
        self.offset.y = -self.frame.size.height - 7.0
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        label.text = String.init(format: "%d %%", Int(round(entry.y)))
        layoutIfNeeded()
    }
}
