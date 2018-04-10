//
//  WebViewViewController.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 08/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
   
   @IBOutlet weak var webView: WKWebView!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
   var url:String?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      activityIndicator(show: true)
      webView.navigationDelegate = self
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      if Reachability.isConnectedToNetwork() {
         loadUrl()
      }else {
         showNoNetworkAlert()
      }
   }
   
   private func activityIndicator(show:Bool) {
      if show {
         activityIndicator.startAnimating()
         activityIndicator.isHidden = false
      }else {
         activityIndicator.stopAnimating()
         activityIndicator.isHidden = true
      }
   }

   func loadUrl() {
      if let unwrappedUrl = url {
         if let url = URL(string: unwrappedUrl) {
            let urlRequest = URLRequest(url: url)
            webView.load(urlRequest)
         }else {
            showInvalidUrlAlert()
         }
      }else {
         activityIndicator(show: false)
         showNoUrlAlert()
      }
   }
   
   private func showNoUrlAlert() {
      let alert = UIAlertController(title: "Error", message: "Unable to load url", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .default , handler: { _ in
         self.dismiss(animated: true, completion: nil)
      }) )
      self.present(alert, animated: true, completion: nil)
   }
   private func showInvalidUrlAlert() {
      let alert = UIAlertController(title: "Error", message: "Not valid url", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .default , handler: { _ in
         self.dismiss(animated: true, completion: nil)
      }) )
      self.present(alert, animated: true, completion: nil)
   }
   
   private func showNoNetworkAlert() {
      let alert = UIAlertController(title: "No network", message: "Network connection is necessary to load url", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
         self.activityIndicator(show: false)
      }) )
      self.present(alert, animated: true, completion: nil)
   }
}

extension WebViewViewController:  WKNavigationDelegate {
   
   func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
      activityIndicator(show: false)
   }
}
