//
//  ViewController.swift
//  AppStoreTransition
//
//  Created by Javier Cruz Santiago on 11/06/20.
//  Copyright © 2020 JCS Development. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var cvPictures: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.cvPictures.register(CardCollectionViewCell.nib, forCellWithReuseIdentifier: CardCollectionViewCell.id)
        self.cvPictures.dataSource = self
        self.cvPictures.delegate = self
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.id, for: indexPath)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = self.view.frame.width - 40
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        
    }
}
