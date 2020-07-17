//
//  WebViewController.swift
//  SeikakuShindan
//
//  Created by Yusuke Mitsugi on 2020/07/17.
//  Copyright © 2020 Yusuke Mitsugi. All rights reserved.
//

import UIKit
import WebKit
import Lottie

protocol PasteDelegate {
    func addText(copyedText: String)
}

class WebViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    var url = "https://logmi.jp/"
    var animationView: AnimationView! = AnimationView()
    var pasteDelegate: PasteDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        let urlRequest = URLRequest(url: URL(string: url)!)
        webView.load(urlRequest)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //アニメーションをスタート
        startAnimation()
    }
    
    func startAnimation() {
        let animation = Animation.named("loading")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: view.frame.size.width,
                                     height: view.frame.size.height)
        animationView.loopMode = .loop
        animationView.backgroundColor = .white
        view.addSubview(animationView)
        animationView.play()
    }
    
    //アニメーションを消すタイミング
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        animationView.removeFromSuperview()
    }

    
    @IBAction func back(_ sender: Any) {
        if UIPasteboard.general.string?.isEmpty != nil {
            pasteDelegate?.addText(copyedText: UIPasteboard.general.string!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
}
