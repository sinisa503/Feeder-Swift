//
//  DownloadService.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 07/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class DownloadService {
   
   public func downloadImage(from url:URL, callback:@escaping (Data?)->()) {
      do {
         DispatchQueue.global(qos: .background).async {
            if let imageData = try? Data(contentsOf: url) {
               callback(imageData)
            }else {
               callback(nil)
            }
         }
      }
   }
   
}
