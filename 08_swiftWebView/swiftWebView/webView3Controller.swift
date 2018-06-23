//
//  webView3Controller.swift
//  swiftWebView
//
//  Created by Atsushi on 2018/05/14.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class webView3Controller: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        let url = URL(string: "http://google.co.jp")
        let urlRequest = URLRequest(url: url!)
        webView.loadRequest(urlRequest)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }

}
