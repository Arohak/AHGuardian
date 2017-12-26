//
//  ChooserViewController.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 14/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit

class ChooserViewController: UIViewController {

    let asyncVC = ASLandingViewController()
    let standartVC = LandingViewController()

    lazy var asyncButton: UIButton = {
        let view = UIButton.newAutoLayout()
        view.setTitle("Async", for: .normal)
        view.addTarget(self, action: #selector(asyncAction), for: .touchUpInside)
        
        return view
    }()
    
    lazy var standartButton: UIButton = {
        let view = UIButton.newAutoLayout()
        view.setTitle("Standart", for: .normal)
        view.addTarget(self, action: #selector(standartAction), for: .touchUpInside)
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose View Controller"

        setupViewConfiguration()
    }
}

//MARK: - ViewConfiguration -
extension ChooserViewController: ViewConfiguration {
    
    func configureViews() {
        self.view.backgroundColor = .gray
    }
    
    func buildViewHierarchy() {
        self.view.addSubview(asyncButton)
        self.view.addSubview(standartButton)
    }
    
    func setupConstraints() {
        asyncButton.autoAlignAxis(toSuperviewAxis: .vertical)
        asyncButton.autoAlignAxis(.horizontal, toSameAxisOf: self.view, withOffset: -20)
        
        standartButton.autoAlignAxis(toSuperviewAxis: .vertical)
        standartButton.autoAlignAxis(.horizontal, toSameAxisOf: self.view, withOffset: 20)
    }
}

//MARK: - Actions -
extension ChooserViewController {
    
    @objc func asyncAction() {
        self.navigationController?.pushViewController(asyncVC, animated: true)
    }
    
    @objc func standartAction() {
        self.navigationController?.pushViewController(standartVC, animated: true)
    }
}
