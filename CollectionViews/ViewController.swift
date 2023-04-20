//
//  ViewController.swift
//  CollectionViews
//
//  Created by Mathijs Bernson on 20/04/2023.
//

import UIKit
import SwiftUI

class ViewController: UICollectionViewController {

    typealias ItemID = String
    typealias SectionID = Int

    // We need to keep a strong reference to the data source, otherwise it will be deallocated
    private var dataSource: UICollectionViewDiffableDataSource<SectionID, ItemID>!

    init() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            // Define the layout for each section in the collection view.
            // This example uses a single section with a simple list layout.
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }

        super.init(collectionViewLayout: layout)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "CollectionView demo"

        let registration = UICollectionView.CellRegistration<UICollectionViewCell, ItemID> { cell, indexPath, identifier in
            cell.contentConfiguration = UIHostingConfiguration {
                HStack {
                    Image(systemName: "star").foregroundStyle(.purple)
                    Text(identifier)
                    Spacer()
                }
            }
        }

        let dataSource = UICollectionViewDiffableDataSource<SectionID, ItemID>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
        })
        self.dataSource = dataSource
        self.collectionView.dataSource = dataSource

        // Populate the collection view with some initial data.
        var snapshot = NSDiffableDataSourceSnapshot<SectionID, ItemID>()
        snapshot.appendSections([0])
        snapshot.appendItems(["Item 1", "Item 2", "Item 3"], toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
