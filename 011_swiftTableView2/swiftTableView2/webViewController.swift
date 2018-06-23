//
//  webViewController.swift
//  swiftTableView2
//
//  Created by Atsushi on 2018/05/14.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class webViewController: UIViewController, UIWebViewDelegate {

    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        let url = URL(string : "https://www.jalan.net/news/article/100005/")
        
        let urlRequest = URLRequest(url: url!)
        webView.loadRequest(urlRequest)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    

    //ブラウザの次に進むと同じ
    @IBAction func susumu(_ sender: Any) {
        webView.goForward()
    }
    
    //ブラウザの前に戻ると同じ
    @IBAction func modoru(_ sender: Any) {
        webView.goBack()
    }
    
    //前のviewに戻る
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
