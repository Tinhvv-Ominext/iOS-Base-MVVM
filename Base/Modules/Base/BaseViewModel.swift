//
//  BaseViewModel.swift
//  Knafeh
//
//  Created by Tinh Vu on 4/9/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation

@objc protocol ViewModelProtocol: class {
    @objc func onShowLoading()
    @objc func onHideLoading()
    @objc func handleError(_ error: Error?)
}

class ViewModel {
    
}
