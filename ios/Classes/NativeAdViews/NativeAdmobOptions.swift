//
//  BannerOptions.swift
//  flutter_native_admob
//
//  Created by Dao Duy Duong on 3/8/20.
//

import UIKit

struct NativeAdmobOptions {
    
    struct NativeTextStyle {
        var fontSize: CGFloat
        var color: UIColor
        var backgroundColor: UIColor? = nil
        var isVisible: Bool = true
        var iosTypeface: String? = nil
        
        mutating func update(JSON: [String: Any]) {
            if let fontSize = JSON["fontSize"] as? CGFloat {
                self.fontSize = fontSize
            }
            
            if let colorString = JSON["color"] as? String {
                self.color = .fromHex(colorString)
            }
            
            if let backgroundColorString = JSON["backgroundColor"] as? String {
                self.backgroundColor = .fromHex(backgroundColorString)
            }
            
            if let isVisible = JSON["isVisible"] as? Bool {
                self.isVisible = isVisible
            }
            
            if let iosTypeface = JSON["iosTypeface"] as? String {
                self.iosTypeface = iosTypeface
            }
        }
    }
    
    var showMediaContent: Bool = true
    var backgroundColor: UIColor?
    var ratingColor: UIColor = .yellow

    var adLabelTextStyle = NativeTextStyle(fontSize: 12, color: .white, backgroundColor: .fromHex("FFCC66"))
    var headlineTextStyle = NativeTextStyle(fontSize: 16, color: .black)
    var advertiserTextStyle = NativeTextStyle(fontSize: 14, color: .black)
    var bodyTextStyle = NativeTextStyle(fontSize: 12, color: .gray)
    var storeTextStyle = NativeTextStyle(fontSize: 12, color: .black)
    var priceTextStyle = NativeTextStyle(fontSize: 12, color: .black)
    var callToActionStyle = NativeTextStyle(fontSize: 15, color: .white, backgroundColor: .fromHex("#4CBE99"))
    
    init() {}
    
    init(_ data: [String: Any]) {
        if let showMediaContent = data["showMediaContent"] as? Bool {
            self.showMediaContent = showMediaContent
        }


        if let backgroundColorString = data["backgroundColor"] as? String {
            backgroundColor = .fromHex(backgroundColorString)
        }
        
        if let ratingColorString = data["ratingColor"] as? String {
            ratingColor = .fromHex(ratingColorString)
        }
        
        if let data = data["adLabelTextStyle"] as? [String: Any] {
            adLabelTextStyle.update(JSON: data)
        }
        
        if let data = data["headlineTextStyle"] as? [String: Any] {
            headlineTextStyle.update(JSON: data)
        }
        
        if let data = data["advertiserTextStyle"] as? [String: Any] {
            advertiserTextStyle.update(JSON: data)
        }
        
        if let data = data["bodyTextStyle"] as? [String: Any] {
            bodyTextStyle.update(JSON: data)
        }
        
        if let data = data["storeTextStyle"] as? [String: Any] {
            storeTextStyle.update(JSON: data)
        }
        
        if let data = data["priceTextStyle"] as? [String: Any] {
            priceTextStyle.update(JSON: data)
        }
        
        if let data = data["callToActionStyle"] as? [String: Any] {
            callToActionStyle.update(JSON: data)
        }
    }
}

