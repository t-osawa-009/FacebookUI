//
//  PostViewController.swift
//  FacebookUI
//
//  Created by takuya on 2016/10/01.
//  Copyright © 2016年 takuya. All rights reserved.
//

import UIKit

final class PostViewController: UIViewController {
    fileprivate var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        
        let rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "man"), style: .done, target: self, action: #selector(rightButtonItemTapped(sender:)))
        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupSearchBar() {
        if let navigationBarFrame = navigationController?.navigationBar.bounds {
            let searchBar = UISearchBar(frame: navigationBarFrame)
            let textField = searchBar.value(forKey: "searchField") as? UITextField
            textField?.textColor = UIColor.white
            textField?.backgroundColor = Color.facebookBackgroundColor
            textField?.textAlignment = .left
            textField?.placeholder = "友達、スポット等を検索"
            searchBar.autocapitalizationType = .none
            searchBar.keyboardType = .default
            navigationItem.titleView = searchBar
            navigationItem.titleView?.frame = searchBar.frame
            self.searchBar = searchBar
        }
    }
    
    func rightButtonItemTapped(sender: Any) {
        
    }
}
