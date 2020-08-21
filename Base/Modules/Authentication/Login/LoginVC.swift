//
//  LoginVC.swift
//  Base
//
//  Created tinhvv-ominext on 8/21/20.
//  Copyright © 2020 Ominext JSC. All rights reserved.
//

import UIKit

class LoginVC: BaseVC {
    
    var viewModel : LoginViewModel {
        willSet {
            newValue.view = self
        }
    }
    
    init(_ viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "LoginVC", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Properties

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel.fetchData()
    }
    
    //MARK: - Private functions
    private func initViews() {
        
    }
    
    private func initData() {
        
    }
    
    //MARK: - Public functions
}

extension LoginVC: LoginViewModelProtocol {
    
}
