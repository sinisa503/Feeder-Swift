//
//  InitialListView.swift
//  Feeder
//
//  Created by Sinisa Vukovic on 05/04/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

protocol FeedListView {
   
   var presenter: FeedListPesentation? { get set }
   func showErrorAlert()
   func showNoNetworkAlert()
   func showToast(message:String)
}
