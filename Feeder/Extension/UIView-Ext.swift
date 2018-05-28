//
//  UIView-Ext.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 28/05/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

extension UIView {
   func showToast(message : String) {
      let toastLabel = UILabel(frame: CGRect(x: self.frame.size.width/2 - 75, y: self.frame.size.height-100, width: 150, height: 35))
      toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
      toastLabel.textColor = UIColor.white
      toastLabel.textAlignment = .center;
      toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
      toastLabel.text = message
      toastLabel.alpha = 1.0
      toastLabel.layer.cornerRadius = 10;
      toastLabel.clipsToBounds  =  true
      self.addSubview(toastLabel)
      UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
      }, completion: {(isCompleted) in
         toastLabel.removeFromSuperview()
      })
   }
}
