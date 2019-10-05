//
//  PrivacyViewController.swift
//  PiggyPatchwork
//
//  Created by 潘立祥 on 2019/9/24.
//  Copyright © 2019 PanLiHsiang. All rights reserved.
//

import UIKit
import WebKit

class PrivacyViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var myWebView: WKWebView!
    
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myWebView.navigationDelegate = self
        
        myWebView.backgroundColor = .white
        
        loadWebView()
    }
    
    func loadWebView() {
        
        let urlString = "https://www.privacypolicies.com/privacy/view/552066cafeaf65d6210d632bf833e166"
        
        guard let url = URL(string: urlString) else { return }
    
        myWebView.load(URLRequest(url: url))
    }
    
    @IBAction func backToHomePage(_ sender: Any) {
        
        navigationController?.popViewController(animated: true)
    }
    
    func webView(
        _ webView: WKWebView,
        didStartProvisionalNavigation navigation: WKNavigation!
    ) {
        
        myActivityIndicator.startAnimating()
    }
    
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        
        myActivityIndicator.stopAnimating()
    }
}
