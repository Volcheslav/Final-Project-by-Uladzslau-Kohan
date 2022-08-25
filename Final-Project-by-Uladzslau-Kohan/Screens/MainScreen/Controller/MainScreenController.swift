//
//  ViewController.swift
//  Final-Project-by-Uladzslau-Kohan
//
//  Created by VironIT on 8/3/22.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet private weak var mainFirstCollection: UICollectionView!
    @IBOutlet private weak var mainSecondCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mainFirstCollection.delegate = self
        mainSecondCollection.delegate = self
        mainFirstCollection.dataSource = self
        mainSecondCollection.delegate = self
        mainFirstCollection.backgroundColor = .clear
      
        // Do any additional setup after loading the view.
    }

}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.mainFirstCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as! MainScreenCollectionViewCell
            cell.cellImage.image = UIImage(named: "burger")
            cell.layer.cornerRadius = 30
            cell.layer.masksToBounds = true
            cell.backgroundColor = .darkGray
            cell.nameLabel.text = "hamburger"
            cell.nameLabel.textColor = .white
            cell.addButton.layer.cornerRadius = cell.addButton.frame.height / 2
            cell.addButton.backgroundColor = .black
            cell.addButton.tintColor = .white
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as!
            SecondMainScreenCollectionViewCell
            cell.cellImage.image = UIImage(named: "burger")
            cell.layer.cornerRadius = 30
            cell.layer.masksToBounds = true
            cell.backgroundColor = .darkGray
            cell.nameLabel.text = "hamburger"
            cell.nameLabel.textColor = .white
            cell.addButton.layer.cornerRadius = cell.addButton.frame.height / 2
            cell.addButton.backgroundColor = .black
            cell.addButton.tintColor = .white
            return cell
        }
     
    }
    
    

}

extension MainScreenViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsInHeigt: CGFloat = 1
        let paddingsHeight: CGFloat = (itemsInHeigt + 1) * 20 + 1
        let avalibalHeight: CGFloat = collectionView.frame.height - paddingsHeight
        let itemWidth = avalibalHeight / itemsInHeigt
        return CGSize(width: itemWidth, height: itemWidth + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}
