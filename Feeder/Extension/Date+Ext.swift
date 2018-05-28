//
//  Date+Ext.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 28/05/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

extension Date {
   
   func isToday() -> Bool {
      return Calendar.current.isDateInToday(self)
   }
}
