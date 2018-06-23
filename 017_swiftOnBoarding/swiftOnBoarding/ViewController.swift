import UIKit
import SwiftyOnboard

class ViewController: UIViewController,SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    @IBOutlet var swiftyOnboard: SwiftyOnboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swiftyOnboard.style = .light
        swiftyOnboard.delegate = self
        swiftyOnboard.dataSource = self
        swiftyOnboard.fadePages = true
        swiftyOnboard.backgroundColor = UIColor(red: 46/256, green: 46/256, blue: 76/256, alpha: 1)
        
    }
    
    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: 2, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
    }
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 3
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = CustomPage.instanceFromNib() as? CustomPage
        view?.image.image = UIImage(named: "\(index).png")
        if index == 0 {
            //On the first page, change the text in the labels to say the following:
            view?.titleLabel.text = "このアプリでは"
            view?.subTitleLabel.text = "いろんな事をシェアしよう"
        } else if index == 1 {
            //On the second page, change the text in the labels to say the following:
            view?.titleLabel.text = "出かけた場所の上空に"
            view?.subTitleLabel.text = "写真を保存したり、落書きをしたり"
        } else {
            //On the thrid page, change the text in the labels to say the following:
            view?.titleLabel.text = "さあはじめましょう！"
            view?.subTitleLabel.text = "楽しい世界へようこそ！"
        }
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = CustomOverlay.instanceFromNib() as? CustomOverlay
        overlay?.skip.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay?.buttonContinue.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let overlay = overlay as! CustomOverlay
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        overlay.buttonContinue.tag = Int(position)
        if currentPage == 0.0 || currentPage == 1.0 {
            overlay.buttonContinue.setTitle("続ける", for: .normal)
            overlay.skip.setTitle("スキップ", for: .normal)
            overlay.skip.isHidden = false
        } else {
            overlay.buttonContinue.setTitle("はじめる!", for: .normal)
            overlay.skip.isHidden = true
        }
    }
    
    
}

