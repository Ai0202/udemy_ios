//
//  soundViewController.swift
//  swiftMousouLine
//
//  Created by Atsushi on 2018/05/14.
//  Copyright © 2018年 Atsushi. All rights reserved.
//

import UIKit
import AVFoundation

class soundViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var imageView2: UIImageView!
    
    var audioPlayer : AVAudioPlayer!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView2.isHidden = true
        timeLabel.isHidden = true
        
        if let url = Bundle.main.url(forResource: "callMusic", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                audioPlayer = nil
            }
        } else {
            fatalError("url is nil.")
        }

    }
    
    @IBAction func tap(_ sender: Any) {
        imageView2.isHidden = false
        timeLabel.isHidden = false
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerCountUp), userInfo: nil, repeats: true)
        
        self.babySound()
        
    }
    
    @objc func timerCountUp() {
        count = count + 1
        timeLabel.text = String(count)
        
    }
    
    func babySound() {
        if let url = Bundle.main.url(forResource: "baby", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                audioPlayer = nil
            }
        } else {
            fatalError("url is nil.")
        }
    }
    
    
    @IBAction func deny(_ sender: Any) {
        audioPlayer.stop()
        dismiss(animated: true, completion: nil)
    }

}
