//
//  News1ViewController.swift
//  SmartyNews
//
//  Created by Atsushi on 2018/06/10.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import SDWebImage

class News4ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate, XMLParserDelegate {
    
    var urlArray = [String]()
    
    var tableView:UITableView = UITableView()
    
    var refreshCntrol:UIRefreshControl!
    
    var webView:UIWebView = UIWebView()
    
    var goBtn:UIButton!
    
    var backBtn:UIButton!
    
    var cancelBtn:UIButton!
    
    var dotsView:DotsLoader! = DotsLoader()
    
    var parser = XMLParser()
    
    var totalBox = NSMutableArray()
    
    var elements = NSMutableDictionary()
    
    var element = String()
    
    var titleString = NSMutableString()
    
    var linkString = NSMutableString()
    
    var urlString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //背景画像を作る
        let imageView = UIImageView()
        //画面いっぱいまで広げる
        imageView.frame = self.view.bounds
        imageView.image = UIImage(named: "4.jpg")
        self.view.addSubview(imageView)
        
        //引っ張って更新
        refreshCntrol = UIRefreshControl()
        //画面読み込みのくるくるの色
        refreshCntrol.tintColor = UIColor.white
        //上から下に引っ張った時に#selectorの中のメソッドが実行される
        refreshCntrol.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        
        //tableViewを作成
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 54.0)
        //tableViewはデフォルトで背景が白だから、透明にして後ろの画像が表示されるようにする
        tableView.backgroundColor = UIColor.clear
        tableView.addSubview(refreshCntrol)
        //addSubview = viewの上に別のviewを乗っける
        self.view.addSubview(tableView)
        
        //webviewを作成
        webView.frame = tableView.frame
        webView.delegate = self
        
        //PCページでも画面に収める
        webView.scalesPageToFit = true
        webView.contentMode = .scaleAspectFit
        
        self.view.addSubview(webView)
        webView.isHidden = true
        
        //進むボタン
        goBtn = UIButton()
        goBtn.frame = CGRect(x: self.view.frame.size.width - 50, y: self.view.frame.size.height - 128, width: 50, height: 50)
        goBtn.setImage(UIImage(named: "go.png"), for: .normal)
        goBtn.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        self.view.addSubview(goBtn)
        
        //戻るボタン
        backBtn = UIButton()
        backBtn.frame = CGRect(x: 10, y: self.view.frame.size.height - 120, width: 50, height: 50)
        backBtn.setImage(UIImage(named: "back.png"), for: .normal)
        backBtn.addTarget(self, action: #selector(backPage), for: .touchUpInside)
        self.view.addSubview(backBtn)
        
        //キャンセルボタン
        cancelBtn = UIButton()
        cancelBtn.frame = CGRect(x: 10, y: 120, width: 50, height: 50)
        cancelBtn.setImage(UIImage(named: "cancel.png"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        self.view.addSubview(cancelBtn)
        
        //ドッツビュー 外部ライブラリ
        dotsView.frame = CGRect(x: 0, y: self.view.frame.size.height / 3, width: self.view.frame.size.width
            , height: 100)
        dotsView.dotsCount = 5
        dotsView.dotsRadius = 10
        self.view.addSubview(dotsView)
        
        goBtn.isHidden = true
        backBtn.isHidden = true
        cancelBtn.isHidden = true
        dotsView.isHidden = true
        
        //パース
        let url:String = "https://www.cnet.com/rss/news/"
        let urlToSend:URL = URL(string:url)!
        parser = XMLParser(contentsOf: urlToSend)!
        totalBox = []
        parser.delegate = self
        parser.parse()
        tableView.reloadData()
        
    }
    
    
    @objc func refresh(){
        perform(#selector(delay), with: nil, afterDelay: 2.0)
    }
    
    @objc func delay(){
        //パース
        //URLを正しく表示させるにはplist>APS>allow Allow Arbitrary Loads>YESにする
        let url:String = "https://www.cnet.com/rss/news/"
        let urlToSend:URL = URL(string:url)!
        parser = XMLParser(contentsOf: urlToSend)!
        totalBox = []
        parser.delegate = self
        parser.parse()
        tableView.reloadData()
        refreshCntrol.endRefreshing()
    }
    
    //webViewを1ページ進める
    @objc func nextPage(){
        webView.goForward()
    }
    
    //webViewを1ページ戻す
    @objc func backPage(){
        webView.goBack()
    }
    
    //webViewを隠す
    @objc func cancel(){
        webView.isHidden = true
        goBtn.isHidden = true
        backBtn.isHidden = true
        cancelBtn.isHidden = true
    }
    
    //tableViewの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //sectionの中のセルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalBox.count
    }
    
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        //totalboxのindexPath.row番目のKey値がtitleの値を入れる
        cell.textLabel?.text = (totalBox[indexPath.row] as AnyObject).value(forKey: "title") as? String
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        cell.textLabel?.textColor = UIColor.white
        print(totalBox[0])
        
        cell.detailTextLabel?.text = (totalBox[indexPath.row] as AnyObject).value(forKey: "link") as? String
        cell.detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 9.0)
        cell.detailTextLabel?.textColor = UIColor.white
        
        let urlStr = urlArray[indexPath.row].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let url:URL = URL(string:urlStr)!
        
        cell.imageView?.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage.png"))
        
        return cell
    }
    
    //セルがタップされた時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //webviewを表示する
        let linkURL = (totalBox[indexPath.row] as AnyObject).value(forKey: "link") as? String
        //        let urlStr = linkURL?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url:URL = URL(string:linkURL!)!
        let urlRequest = NSURLRequest(url: url)
        webView.loadRequest(urlRequest as URLRequest)
        
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
        dotsView.isHidden = false
        dotsView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        dotsView.isHidden = true
        dotsView.stopAnimating()
        webView.isHidden = false
        goBtn.isHidden = false
        backBtn.isHidden = false
        cancelBtn.isHidden = false
    }
    
    //タグを見つけた時
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        element = elementName
        
        if element == "item"{
            
            elements = NSMutableDictionary()
            elements = [:]
            titleString = NSMutableString()
            titleString = ""
            linkString = NSMutableString()
            linkString = ""
            urlString = String()
            
        }else if element == "media:thumbnail"{
            
            urlString = attributeDict["url"]!
            urlArray.append(urlString)
        }
    }
    
    //タグの間いにデータがあった時(開始タグと終了タグでくくられた箇所にデータが存在した時に実行されるメソッド)
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element == "title"{
            
            titleString.append(string)
            
            
        }else if element == "link"{
            
            linkString.append(string)
        }
    }
    
    
    //タグの終了を見つけた時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //itemという要素の中にあるなら、
        if elementName == "item"{
            
            //titleString(linkString)の中身が空でないなら
            if titleString != ""{
                //elementsにキー値を付与しながらtitleString[linkString]をセットする
                elements.setObject(titleString, forKey: "title" as NSCopying)
            }
            
            if linkString != ""{
                //elementsにキー値を付与しながらtitleString[linkString]をセットする
                elements.setObject(linkString, forKey: "link" as NSCopying)
            }
            
            elements.setObject(urlString, forKey: "url" as NSCopying)
            
            //TotalBoxの中にelementsを入れる
            totalBox.add(elements)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
