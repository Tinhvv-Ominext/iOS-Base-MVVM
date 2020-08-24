//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created ___FULLUSERNAME___ on ___DATE___.
//  Copyright © ___YEAR___ ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class ___VARIABLE_productName:identifier___VC: BaseVC {
    
    var viewModel : ___VARIABLE_productName:identifier___ViewModel {
        willSet {
            newValue.view = self
        }
    }
    
    init(_ viewModel: ___VARIABLE_productName:identifier___ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "___VARIABLE_productName:identifier___VC", bundle: nil)
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

extension ___VARIABLE_productName:identifier___VC: ___VARIABLE_productName:identifier___ViewModelProtocol {
    
}
