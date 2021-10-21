//
//  PhotosViewController.swift
//  Gora
//
//  Created by Антон Усов on 19.10.2021.
//

import UIKit

class PhotosViewController: UIViewController {
    
    var user: User!
    
    private var photos: [Photo] = []
    
    private var collectionView: UICollectionView!
    
    private let networkManager = PhotoManager()
    
    private let imageManager = ImageManager()
    
    private let inset: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        collectionViewConfig()
        
        title = "Photos"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func collectionViewConfig() {
        let layout = CustomLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.contentInset = .init(top: inset, left: inset, bottom: inset, right: inset)
        collectionView.register(PhotoCell.self,
                                forCellWithReuseIdentifier: PhotoCell.identifier)
        
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.delegate = self
    }
    
    private func loadData() {
        networkManager.getAlbums(userID: user.id) { [weak self] (newPhotos) in
            self?.photos = newPhotos
            self?.collectionView.reloadData()
            
            guard self != nil else { return }
            for i in self!.photos {
                self?.imageManager.getImage(url: i.url, completion: { [weak self] (newImage) in
                    i.image = newImage  as Data?
                    self?.collectionView.reloadData()
                })
            }
        }
    }
    
}


extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        
        let title = photos[indexPath.item].title
        
        let image = photos[indexPath.item].image
        
        cell.download( image: image, title: title)
        
        return cell
    }
    
}


extension PhotosViewController: CustomLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        
        let imgHeight = calculateImageHeight(scaledToWidth: cellWidth)
        
        let textHeight = requiredHeight(text: photos[indexPath.item].title, cellWidth: cellWidth)
        
        return (imgHeight + textHeight + 20)
    }
    
    func calculateImageHeight (scaledToWidth: CGFloat) -> CGFloat {
        let oldWidth = view.frame.size.width - 2 * inset
        
        let scaleFactor = scaledToWidth / oldWidth
        
        let newHeight = CGFloat( view.frame.size.width - 2 * inset ) * scaleFactor
        
        return newHeight
    }
    
    func requiredHeight(text:String , cellWidth : CGFloat) -> CGFloat {
        let font = UIFont(name: "HelveticaNeue", size: 17.0)
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellWidth, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        
        return label.frame.height
    }
    
}


