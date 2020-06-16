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
    
    private var transition: CardTransition?
    
    private lazy var cardModels: [CardContentViewModel] = [
        CardContentViewModel(title: "Título 1", description: "Descripción 1", date: "11-04-2020", image: UIImage(named: "bg1.png")!.resize(toWidth: UIScreen.main.bounds.width * ( 1 / 0.96 ))),
        CardContentViewModel(title: "Título 2", description: "Descripción 2", date: "11-04-2020", image: UIImage(named: "bg1.png")!.resize(toWidth: UIScreen.main.bounds.width * ( 1 / 0.96 ))),
        CardContentViewModel(title: "Título 3", description: "Descripción 3", date: "11-04-2020", image: UIImage(named: "bg1.png")!.resize(toWidth: UIScreen.main.bounds.width * ( 1 / 0.96 ))),
        CardContentViewModel(title: "Título 4", description: "Descripción 4", date: "11-04-2020", image: UIImage(named: "bg1.png")!.resize(toWidth: UIScreen.main.bounds.width * ( 1 / 0.96 ))),
        CardContentViewModel(title: "Título 5", description: "Descripción 5", date: "11-04-2020", image: UIImage(named: "bg1.png")!.resize(toWidth: UIScreen.main.bounds.width * ( 1 / 0.96 ))),
        
    ]
    
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
        return cardModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardCollectionViewCell.id, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? CardCollectionViewCell else {
            return
        }
        cell.cardContentView.cardViewModel = cardModels[indexPath.row]
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
        
        cell.freezeAnimations()
        
        guard let currentCellFrame = cell.layer.presentation()?.frame else { return }
        
        guard let cardPresentationFrameOnScreen = cell.superview?.convert(currentCellFrame, to: nil) else { return }
        
        let cardFrameWithoutTransform = { () -> CGRect in
            let center = cell.center
            let size = cell.bounds.size
            let rect = CGRect(x: center.x - size.width / 2,
                              y: center.y - size.height / 2,
                              width: size.width,
                              height: size.height)
            return cell.superview!.convert(rect, to: nil)
        }()
        
        guard let detailViewController = storyboard?.instantiateViewController(identifier: "CardDetailViewControllerId") as? CardDetailViewController else { return }
        
        detailViewController.cardViewModel = cardModels[indexPath.row].highlightedImage()
        detailViewController.unhighlightedCardViewModel = cardModels[indexPath.row]
        
        let params = CardTransition.Params(fromCardFrame: cardPresentationFrameOnScreen,
                                           fromCardFrameWithoutTransform: cardFrameWithoutTransform,
                                           fromCell: cell)
        
        self.transition = CardTransition(params: params)
        detailViewController.transitioningDelegate = self.transition
        detailViewController.modalPresentationCapturesStatusBarAppearance = true
        detailViewController.modalPresentationStyle = .custom
        
        self.present(detailViewController, animated: true) { [unowned cell] in
            cell.unfreezeAnimations()
        }
    }
}
