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
        let url = URL(string: urlString ?? "")
        let request = URLRequest(url: url!)
        webView.load(request)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
