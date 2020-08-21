//
//  LoginViewModel.swift
//  Base
//
//  Created tinhvv-ominext on 8/21/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import Foundation

protocol LoginViewModelProtocol: ViewModelProtocol {
    
}

class LoginViewModel {
    var view : LoginViewModelProtocol!
    var object = Login()
    
    func fetchData() {
        
    }
    
}
