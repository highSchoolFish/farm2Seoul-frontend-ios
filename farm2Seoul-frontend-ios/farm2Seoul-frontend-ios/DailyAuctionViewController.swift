//
//  DailyAuctionViewController.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/18.
//

import UIKit
import Moya
import Alamofire

class DailyAuctionViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dailyAuctionCollectionView: UICollectionView!
    
    var dailyAuctionData:[DailyAuctionResponse] = []
    let mainVC = MainTabViewController()
    let interval = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    var fetchingMore: Bool = false
    var page: Int = 1
    var listTotalCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dailyAuctionCollectionView.register(UINib(nibName: "DailyAuctionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "DailyAuctionCell")
        dailyAuctionCollectionView.dataSource = self
        dailyAuctionCollectionView.delegate = self
        dailyAuctionCollectionView.isPrefetchingEnabled = true
        // total count 가져오기
        self.getDailyAuctionTotalCount()
        // 첫 10개 보여주기
        self.getDailyAuction(page: self.page)
        // 이후 스크롤 할때 바닥에 닿으면 page+1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        beginBatchFetch()
        if dailyAuctionCollectionView.contentOffset.y > (dailyAuctionCollectionView.contentSize.height - dailyAuctionCollectionView.bounds.size.height) {
            print("끝에 도달")
            if !fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    private func beginBatchFetch() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.page += 1
            
            self.getDailyAuction(page: self.page)
            self.fetchingMore = false
            self.dailyAuctionCollectionView.reloadData()
        })
    }
    
    private func getDailyAuction(page: Int){
        let authKey = "766c476c676b6e793132345770716c57"
        let requestType = "json"
        let serviceName = "GarakGradePrice"
//        self.startIndex = self.endIndex
//        self.endIndex += page
        let path = "http://openapi.seoul.go.kr:8088/\(authKey)/\(requestType)/\(serviceName)/\(self.startIndex)/\(self.endIndex)"
        
        let url = URL(string: path)!
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(path).responseJSON { (response) in
            let result = response.result
            var auctions = [DailyAuctionResponse]()
            switch result {
            case .success(let value as [String:Any]):
                print("통신성공")
                if let dict = value["GarakGradePrice"] as? [String: Any],
                   let dailyAuction = dict["row"] as? [Dictionary<String,AnyObject>] {
                    dailyAuction.forEach{auctions.append(DailyAuctionResponse(auctionDictionary: $0))}
                }
                self.dailyAuctionData = auctions
                print("dailyAuctionData count \(self.dailyAuctionData.count)")
                
                self.dailyAuctionCollectionView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
                
            default:
                fatalError()
            }
        }
        
    }
    
    // 전체 list total count // 1821
    private func getDailyAuctionTotalCount() {
        
        let authKey = "766c476c676b6e793132345770716c57"
        let requestType = "json"
        let serviceName = "GarakGradePrice"
        let path = "http://openapi.seoul.go.kr:8088/\(authKey)/\(requestType)/\(serviceName)/1/1"
        let url = URL(string: path)!
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(path).responseJSON { (response) in
            let result = response.result
            var auctions = [DailyAuctionResponse]()
            switch result {
            case .success(let value as [String:Any]):
                print("통신성공")
                if let dict = value["GarakGradePrice"] as? [String: Any],
                   let listTotalCount = dict["list_total_count"] as? Int {
                    print("list_total_count = \(listTotalCount)")
                    self.listTotalCount = listTotalCount
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            default:
                fatalError()
            }
        }
    }
}

extension DailyAuctionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("cell data count \(dailyAuctionData.count)")
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
