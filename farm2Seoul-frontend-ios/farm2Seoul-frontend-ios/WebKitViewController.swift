//
//  WebKitViewController.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/25.
//

import UIKit
import WebKit
class WebKitViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    var urlString : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeRecognizer()
        let url = URL(string: urlString ?? "")
        let request = URLRequest(url: url!)

        webView.load(request)
    }
    

    func swipeRecognizer() {
            let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture(_:)))
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
            self.view.addGestureRecognizer(swipeRight)
            
        }
        
        @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer){
            if let swipeGesture = gesture as? UISwipeGestureRecognizer {
                switch swipeGesture.direction{
                case UISwipeGestureRecognizer.Direction.right:
                    // 스와이프 시, 원하는 기능 구현.
                    self.dismiss(animated: true, completion: nil)
                default: break
                }
            }
        }
}
