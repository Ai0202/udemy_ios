//
//  SNSViewController.swift
//  swiftInstaCamera
//
//  Created by Atsushi on 2018/05/28.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import Social

class SNSViewController: UIViewController {
    
    var endImage = UIImage()
    
    var myComposeView : SLComposeViewController!
    
    @IBOutlet weak var endImageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        endImageView.image = endImage

    }
    
    @IBAction func share(_ sender: Any) {
        let alertController = UIAlertController(title: "SNSへ投稿", message: "投稿するSNSを洗濯してください", preferredStyle: .actionSheet)
        
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: {(action:UIAlertAction!) -> Void in})
        
        let defaultAction1:UIAlertAction = UIAlertAction(title: "Facebook", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) -> Void in
            
            self.postFacebook()
        })
        
        let defaultAction2:UIAlertAction = UIAlertAction(title: "twitter", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) -> Void in
            
            self.postTwitter()
        })
        
        let defaultAction3:UIAlertAction = UIAlertAction(title: "LINE", style: UIAlertActionStyle.default, handler: {(action:UIAlertAction!) -> Void in
            
            self.postLINE()
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction1)
        alertController.addAction(defaultAction2)
        alertController.addAction(defaultAction3)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    @IBAction func save(_ sender: AnyObject) {
        
        //アラートを表示する
        let alertController = UIAlertController(title: "画像を保存しました。",
                                                message: "OKボタンを押してください",
                                                preferredStyle: .alert)
        
        let okAction:UIAlertAction = UIAlertAction(title: "OK",
                                                   style: UIAlertActionStyle.default,
                                                   handler:{
                                                        (action:UIAlertAction!) -> Void in
            
                                                        UIImageWriteToSavedPhotosAlbum(self.endImageView.image!, self, nil, nil)
        })
        
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func postTwitter(){
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        myComposeView.setInitialText(textView.text)
        myComposeView.add(endImageView.image)
        
        self.present(myComposeView, animated: true, completion: nil)
    }
    
    func postFacebook(){
        myComposeView = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
//        myComposeView.setInitialText(textView.text)
        myComposeView.add(endImageView.image)
        
        self.present(myComposeView, animated: true, completion: nil)
    }
    
    func postLINE() {
        let pastBoard: UIPasteboard = UIPasteboard.general
        
        pastBoard.setData(UIImageJPEGRepresentation(endImageView.image!, 0.75)!, forPasteboardType: "public.png")
        pastBoard.setValue(textView.text, forPasteboardType:textView.text)
        
        let lineUrlString: String = String(format: "line://msg/image/%@", pastBoard.name as CVarArg)
        
        
        UIApplication.shared.open(NSURL(string: lineUrlString)! as URL)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(textView.isFirstResponder){
            textView.resignFirstResponder()
        }
    }

}
