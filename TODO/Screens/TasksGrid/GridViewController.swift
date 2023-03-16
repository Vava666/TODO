//
//  GridViewController.swift
//  TODO
//
//  Created by Artem Vavilov on 02.03.2023.
//

import UIKit
import TinyConstraints

//MARK: - Protocols
protocol GridViewControllerProtocol: AnyObject {
    func loadData(items: [TaskModelDTO])
    func updateData(with taskModelDTO: TaskModelDTO, on index: Int)
    func deleteData(on index: Int)
}

final class GridViewController: UIViewController {
    
    //MARK: - Public properties
    var presenter: GridViewPresenterProtocol?
    var dataSource: [CellModel] = [] {
        didSet {
            dataSource.sort()
            addEmtyCell()
            collection.reloadData()
        }
    }
    
    //MARK: - Private properties
    private let backView = UIView()
    private let headerView = HeaderView()
    private let collection: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        return collection
    }()
    
    //MARK: - Lifecycle
    override func loadView() {
        super.loadView()
        setup()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
    //MARK: - Private properties
    private func setup() {
        addSubviews()
        setupConstraints()
        setupView()
        setupCollection()
    }
    
    private func addSubviews() {
        view.addSubview(backView)
        backView.addSubview(headerView)
        backView.addSubview(collection)
    }
    
    private func setupConstraints() {
        backView.edgesToSuperview(usingSafeArea: true)
        headerView.edgesToSuperview(excluding: .bottom)
        headerView.height(to: backView, multiplier: 0.25)
        
        collection.topToBottom(of: headerView, offset: 12)
        collection.edgesToSuperview(excluding: .top, insets: .left(Constants.space * 2) + .right(Constants.space * 2))
    }
    
    private func setupView() {
        view.backgroundColor = ColorsInter.background
        backView.backgroundColor = .clear
    }
    
    private func setupCollection() {
        collection.register(CellView.self, forCellWithReuseIdentifier: Constants.reuseIdentifier)
        collection.register(EmptyCellView.self, forCellWithReuseIdentifier: Constants.reuseIdentifierEmpty)
        collection.delegate = self
        collection.dataSource = self
    }
    
    private func didCellTapped(item: CellModel, index: Int) {
        switch item.type {
        case .task(let taskModelDTO):
            presenter?.closeTask(taskModelDTO: taskModelDTO, index: index)
        case .empty:
            presenter?.addNewTask(index: index)
        }
    }
    
    private func configureContextMenu(index: Int) -> UIContextMenuConfiguration {
        let context = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { (action) -> UIMenu? in
            let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { (_)  in
                let item = self.dataSource[index]
                switch item.type {
                case .task(let taskModelDTO):
                    self.presenter?.didTaskEdit(taskModelDTO: taskModelDTO, index: index)
                case .empty:
                    return
                }
            }
            
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), identifier: nil, discoverabilityTitle: nil,attributes: .destructive, state: .off) { (_) in
                let item = self.dataSource[index]
                switch item.type {
                case .task(let taskModelDTO):
                    self.presenter?.didTaskDelete(taskModelDTO: taskModelDTO, index: index)
                case .empty:
                    return
                }
            }
            
            return UIMenu(title: "Options", image: nil, identifier: nil, options: UIMenu.Options.displayInline, children: [edit,delete])
        }
        
        return context
    }
    
    private func addEmtyCell() {
        let emptySource = dataSource.filter({ cell in
            switch cell.type {
            case .task(_):
                return false
            case .empty:
                return true
            }
        })
        if emptySource.isEmpty {
            dataSource.append(CellModel(type: .empty))
        }
    }
    
    private func updateProgressView() {
        let taskCount = dataSource.lazy.filter({
            switch $0.type {
            case .task(_):
                return true
            case .empty:
                return false
            }
        }).count
        
        let taskComplCount = dataSource.lazy.filter({
            switch $0.type {
            case .task(let task):
                if task.condition == .closed {
                    return true
                } else {
                    return false
                }
            case .empty:
                return false
            }
        }).count
        
        headerView.updateProgress(Float(taskComplCount) / Float(taskCount))
    }
    
    private func checkTaskConditions() {
        let taskCount = dataSource.lazy.filter({
            switch $0.type {
            case .task(_):
                return true
            case .empty:
                return false
            }
        }).count
        
        let taskComplCount = dataSource.lazy.filter({
            switch $0.type {
            case .task(let task):
                if task.condition == .closed {
                    return true
                } else {
                    return false
                }
            case .empty:
                return false
            }
        }).count
        
        if taskCount > 0 {
            presenter?.closeTaskList(taskComplCount == taskCount)
        } else {
            presenter?.closeTaskList(false)
        }
    }
}

//MARK: - Protocol
extension GridViewController: GridViewControllerProtocol {
    
    func loadData(items: [TaskModelDTO]) {
        let cellData = items.compactMap { dto in
            CellModel(type: .task(dto))
        }
        dataSource.append(contentsOf: cellData)
        updateProgressView()
    }
    
    func updateData(with taskModelDTO: TaskModelDTO, on index: Int) {
        let cellModel = CellModel(type: .task(taskModelDTO))
        dataSource[index] = cellModel
        updateProgressView()
        checkTaskConditions()
    }
    
    func deleteData(on index: Int) {
        dataSource.remove(at: index)
        updateProgressView()
        checkTaskConditions()
    }
}

//MARK: - Delegate\Datasource
extension GridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collection.frame.width / 2) - Constants.space , height: (collection.frame.width / 2) - Constants.space)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.space
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.space * 2
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let index = indexPath.row
        let type = dataSource[index].type
        switch type {
        case .task(_):
            return configureContextMenu(index: index)
        case .empty:
            return nil
        }
    }
}

extension GridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let item = dataSource[indexPath.row]
        didCellTapped(item: item, index: index)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = dataSource[indexPath.row]
        switch data.type {
        case .task(let taskModelDTO):
            let cell = collection.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifier, for: indexPath) as! CellView
            cell.configure(with: taskModelDTO)
            return cell
        case .empty:
            let cell = collection.dequeueReusableCell(withReuseIdentifier: Constants.reuseIdentifierEmpty, for: indexPath) as! EmptyCellView
            return cell
        }
    }
}

//MARK: - Ext
extension GridViewController {
    enum Constants {
        static let reuseIdentifier = "cell"
        static let reuseIdentifierEmpty = "emptyCell"
        static let space = CGFloat(2)
    }
}
