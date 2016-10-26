//
//  PostViewController.swift
//  FacebookUI
//
//  Created by takuya on 2016/10/01.
//  Copyright © 2016年 takuya. All rights reserved.
//

import UIKit

final class PostViewController: UIViewController {
    @IBOutlet fileprivate weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(cellType: PostCollectionViewCell.self)
            flowLayout.scrollDirection = .vertical
            collectionView.collectionViewLayout = flowLayout
        }
    }
    fileprivate var searchBar: UISearchBar!
    fileprivate var fullScreenable: FullScreenable!
    fileprivate let flowLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        let rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "man"), style: .done, target: self, action: #selector(rightButtonItemTapped(sender:)))
        collectionView.delegate = self
        
        fullScreenable = FullScreenable(scrollDelegate: self, fromViewController: self)
        collectionView.delegate = (fullScreenable as UICollectionViewDelegate)

        navigationItem.rightBarButtonItem = rightButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        flowLayout.itemSize = CGSize.init(width: collectionView.frame.width, height: PostCollectionViewCell.height())
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

extension PostViewController: UICollectionViewDelegate {

}

extension PostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: PostCollectionViewCell.self, for: indexPath)
        return cell
    }
}
