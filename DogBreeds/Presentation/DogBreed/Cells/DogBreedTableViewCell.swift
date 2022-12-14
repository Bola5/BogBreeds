//
//  DogBreedTableViewCell.swift
//  DogBreeds
//
//  Created by Bola Fayez on 31/10/2022.
//

import UIKit

class DogBreedTableViewCell: UITableViewCell {

    // MARK: - Cell constants
    private enum Constants {
        enum Cell {
            static let reuseIdentifier = NSStringFromClass(DogBreedImageCollectionViewCell.self)
        }
    }
    
    // MARK: - UI
    private let containerView = UIView()
    private let collectionView: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: DogBreedFlowLayout())
    
    // MARK: - Properties
    private var breedImages: [DogBreedLayoutViewModel.DogBreedImageLayoutViewModel]?
    
    // MARK: - Action
    private var onActionEvent: ((DogBreedAction) -> Void)?
    
    // MARK: - Init
    // Cell style
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    // MARK: - With a coder
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setupViews
    private func setupViews() {
        
        selectionStyle = .none
        
        // containerView
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        // collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        collectionView.register(DogBreedImageCollectionViewCell.self, forCellWithReuseIdentifier: Constants.Cell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
    }

    
}

// MARK: - Load Data
extension DogBreedTableViewCell {
    
    func loadViewWithLayoutViewModel(breedImages: [DogBreedLayoutViewModel.DogBreedImageLayoutViewModel]?, onAction: ((DogBreedAction) -> Void)?) {
        guard let breedImages = breedImages else { return }

        self.breedImages = breedImages
        self.onActionEvent = onAction
        collectionView.reloadData()
    }
    
}

// MARK: - CollectionView Data source
extension DogBreedTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.breedImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cell.reuseIdentifier, for: indexPath)
        
        let layoutViewModel = self.breedImages?[indexPath.row]
        
        guard let layoutViewModel = layoutViewModel else {
            return cell
        }
        
        if let cell = cell as? DogBreedImageCollectionViewCell {
            cell.loadDataWithLayoutViewModel(breedImage: layoutViewModel, onAction: self.onActionEvent, onSelectFav: { [weak self] isFav in
                self?.breedImages?[indexPath.row].updateFav(isFav: isFav)
            })
        }
        
        return cell
        
    }
    
}

// MARK: - CollectionView Flow Layout
extension DogBreedTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }

}
