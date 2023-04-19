//
//  DailyAuctionViewController.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/18.
//

import UIKit

class DailyAuctionViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dailyAuctionCollectionView: UICollectionView!
    
    var dailyAuctionData:[DailyAuctionModel] = []
    let mainVC = MainTabViewController()
    let interval = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dailyAuctionCollectionView.register(UINib(nibName: "DailyAuctionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "DailyAuctionCell")
        dailyAuctionCollectionView.dataSource = self
        dailyAuctionCollectionView.delegate = self
        
        dailyAuctionData.append(DailyAuctionModel.init(name: "1번", price: 155500, weight: 10, rank: "상"))
        dailyAuctionData.append(DailyAuctionModel.init(name: "2번", price: 2040, weight: 20, rank: "하"))
        dailyAuctionData.append(DailyAuctionModel.init(name: "3번", price: 42200, weight: 30, rank: "중"))
        dailyAuctionData.append(DailyAuctionModel.init(name: "4번", price: 60430, weight: 40, rank: "상"))
        dailyAuctionData.append(DailyAuctionModel.init(name: "5번", price: 14200, weight: 50, rank: "상"))
        dailyAuctionData.append(DailyAuctionModel.init(name: "6번", price: 14300, weight: 60, rank: "하"))
        dailyAuctionData.append(DailyAuctionModel.init(name: "7번", price: 10550, weight: 100, rank: "하"))
        
    }
    
}

extension DailyAuctionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dailyAuctionData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let auctionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyAuctionCell", for: indexPath) as? DailyAuctionCollectionViewCell else {
            return UICollectionViewCell()
        }
        auctionCell.generateCell(dailyAuction:dailyAuctionData[indexPath.item])
        return auctionCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 2 - 10.0
        
        return CGSize(width: width, height: 150)
    }
    
    // CollectionView Cell의 위아래 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    // CollectionView Cell의 옆 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return interval
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.section), \(indexPath.row)")
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailInfoViewController else { return }
        // 화면 전환 애니메이션 설정
        detailVC.modalTransitionStyle = .coverVertical
        // 전환된 화면이 보여지는 방법 설정 (fullScreen)
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true, completion: nil)
    }
    
}
//    override var isSelected: Bool {
//        didSet {
//            if isSelected {
//                print("cell view touched")
//                guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailInfoViewController else { return }
//                // 화면 전환 애니메이션 설정
//                detailVC.modalTransitionStyle = .coverVertical
//                // 전환된 화면이 보여지는 방법 설정 (fullScreen)
//                detailVC.modalPresentationStyle = .fullScreen
//                self.present(detailVC, animated: true, completion: nil)
//            }
//        }
//    }
