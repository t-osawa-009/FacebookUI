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
        }
    }
    fileprivate var previousScrollViewYOffset: CGFloat = 0.0
    fileprivate var searchBar: UISearchBar!
    fileprivate var fullScreenable: FullScreenable!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        let rightButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "man"), style: .done, target: self, action: #selector(rightButtonItemTapped(sender:)))
        fullScreenable = FullScreenable(scrollDelegate: collectionView.delegate!)
        collectionView.delegate = (fullScreenable as UICollectionViewDelegate)
        
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

extension PostViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let navigationBarFrame = navigationController?.navigationBar.frame else {return}
        var mutablenavigationBarFrame = navigationBarFrame
        let size = mutablenavigationBarFrame.size.height - 21
        let framePercentageHidden = ((20 - mutablenavigationBarFrame.origin.y) / (mutablenavigationBarFrame.size.height - 1));
        let scrollOffset = scrollView.contentOffset.y
        let scrollDiff = scrollOffset - self.previousScrollViewYOffset
        let scrollHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom
        
        if scrollOffset <= -scrollView.contentInset.top {
            mutablenavigationBarFrame.origin.y = 20
        } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
            mutablenavigationBarFrame.origin.y = -size
        } else {
            mutablenavigationBarFrame.origin.y = min(20, max(-20, mutablenavigationBarFrame.origin.y - scrollDiff))
        }
        navigationController?.navigationBar.frame = mutablenavigationBarFrame
        updateBarButtonItems(alpha: 1 - framePercentageHidden)
        self.previousScrollViewYOffset = scrollOffset;
    }
    
    func stoppedScrolling() {
        guard let frame = navigationController?.navigationBar.frame else {return}
        if frame.origin.y < 20 {
            self.animateNavBarTo(y: frame.size.height - 21)
        }
    }
    
    func animateNavBarTo(y: CGFloat) {
        guard let navigationBarFrame = navigationController?.navigationBar.frame else {return}
        var mutablenavigationBarFrame = navigationBarFrame
        
        UIView.animate(withDuration: 0.2) {
            let alpha: CGFloat =  {
                if mutablenavigationBarFrame.origin.y >= y {
                    return 0
                } else {
                    return 1
                }
            }()
            mutablenavigationBarFrame.origin.y = y
            self.navigationController?.navigationBar.frame = navigationBarFrame
            self.updateBarButtonItems(alpha: CGFloat(alpha))
        }
    }
    
    func updateBarButtonItems(alpha: CGFloat) {
        if let leftButtonItems = navigationController?.navigationItem.leftBarButtonItems {
            for (_, value) in (leftButtonItems.enumerated()) {
                value.customView?.alpha = alpha
            }
        }
        
        if let rightBarButtonItems = navigationController?.navigationItem.rightBarButtonItems {
            for (_, value) in (rightBarButtonItems.enumerated()) {
                value.customView?.alpha = alpha
            }
        }
        navigationItem.titleView?.alpha = alpha
        navigationController?.navigationBar.tintColor = navigationController?.navigationBar.tintColor.withAlphaComponent(alpha)
    }
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

extension PostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: PostCollectionViewCell.height())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
