//
//  NextViewController.swift
//  swiftWonderList
//
//  Created by Atsushi on 2018/05/27.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit

class NextViewController: UIViewController, UITextViewDelegate, UIDocumentInteractionControllerDelegate {
    
//    lazy private var documentInteractionController = UIDocumentInteractionController()
    
    var selectedNumber = 0

    @IBOutlet weak var textView: UITextView!
    
    var screenShotImage = UIImage()
    
    var titleArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //userDefaultsにarrayがあれば実行
        if UserDefaults.standard.object(forKey: "array") != nil {
            
            //UserDefaultsの中身すべて取得
            titleArr = UserDefaults.standard.object(forKey: "array") as! [String]
            
            //前のページで選択された番号の要素をtextViewに渡す
            textView.text = titleArr[selectedNumber]
        }
    }
    
//    タッチしてキーボードを閉じる
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        }
    }
    
    func takeScreenShot() {
        // キャプチャしたい枠を決める
        let rect = CGRect(x: textView.frame.origin.x, y: textView.frame.origin.y, width: textView.frame.width, height: textView.frame.height)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        textView.drawHierarchy(in: rect, afterScreenUpdates: true)
        screenShotImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
    }
    
    @IBAction func shareLINE(_ sender: Any) {
        takeScreenShot()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            let pastBoard: UIPasteboard = UIPasteboard.general
            
            pastBoard.setData(UIImageJPEGRepresentation(self.screenShotImage, 0.75)!, forPasteboardType: "public.png")
            
            let lineUrlString: String = String(format: "line://msg/image/%@", pastBoard.name as CVarArg)
            
            UIApplication.shared.open(NSURL(string: lineUrlString)! as URL)
            
        }
    }

}
