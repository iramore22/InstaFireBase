//
//  SearchCollectionViewController.swift
//  InstElMachine
//
//  Created by infuntis on 12/07/17.
//  Copyright © 2017 gala. All rights reserved.
//

import Foundation
import UIKit

class SearhCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    let reuseIdentifier = "cell"
    let cellsInRow:CGFloat = 3
    let spaceBetweenCells:CGFloat = 8
    var foundPosts: [Post] = []
    var hashTag: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ("#\(hashTag!)")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foundPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! SearchCollectionViewCell
        cell.foundImage.downloadImage(from: foundPosts[indexPath.row].imageUrl)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = (collectionView.bounds.width - (spaceBetweenCells*(cellsInRow+1)))/cellsInRow
        return CGSize(width: cellSize ,height: cellSize)
    }
}

class SearchCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var foundImage: UIImageView!
}
