//
//  DailyAuctionViewController.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/18.
//

import UIKit
import Moya
import Alamofire
import Tabman

class DailyAuctionViewController: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var dailyAuctionCollectionView: UICollectionView!
    @IBOutlet weak var defaultView: UIView!
    
    var searchData:[DailyAuctionResponse] = []
    var dailyAuctionData:[DailyAuctionResponse] = []
    let interval = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    var fetchingMore: Bool = false
    var page: Int = 1
    var startIndex: Int = 1
    var endIndex: Int = 20
    var listTotalCount: Int = 0
    var isSearchView: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidload")
        defaultView.isHidden = true
        self.dailyAuctionCollectionView.register(UINib(nibName: "DailyAuctionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "DailyAuctionCell")
        self.dailyAuctionCollectionView.dataSource = self
        self.dailyAuctionCollectionView.delegate = self
        getCurrentDateTime()
    }
    
    func getCurrentDateTime(){
        let formatter = DateFormatter() //객체 생성
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy. MM. dd" //데이터 포멧 설정
        let str = formatter.string(from: Date()) //문자열로 바꾸기
        dateLabel.text = "\(str) 일별경매"   //라벨에 출력
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("DailyAuctionVC viewDidAppear")
        
        self.getDailyAuctionTotalCount()
        self.getDailyAuction(page: self.page, startIndex: self.startIndex, endIndex: self.endIndex)
        // 이후 스크롤 할때 바닥에 닿으면 page+1
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isSearchView {
            return
        }
        else {
            if scrollView.contentOffset.y + 300 > (dailyAuctionCollectionView.contentSize.height - dailyAuctionCollectionView.bounds.size.height) {
                print("끝에 도달")
                if !fetchingMore {
                    beginBatchFetch()
                    self.dailyAuctionCollectionView.reloadData()
                }
            }
        }
    }
    
    
    private func beginBatchFetch() {
        fetchingMore = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            self.page += 1
            // 2, 11-20
            self.startIndex = self.endIndex + 1
            self.endIndex = self.page * 20
            self.getDailyAuction(page: self.page, startIndex: self.startIndex, endIndex: self.endIndex)
            
            //            self.dailyAuctionData = self.dailyAuctionService.getDailyAuction(page: self.page, startIndex: self.startIndex, endIndex: self.endIndex, productName: self.mainTabVC.searchText)
            self.fetchingMore = false
            self.dailyAuctionCollectionView.reloadData()
        })
    }
    
    private func getDailyAuction(page: Int, startIndex: Int, endIndex: Int){
        let authKey = "766c476c676b6e793132345770716c57"
        let requestType = "json"
        let serviceName = "GarakGradePrice"
        let path = "http://openapi.seoul.go.kr:8088/\(authKey)/\(requestType)/\(serviceName)/\(self.startIndex)/\(self.endIndex)"
        
        print("\(self.startIndex) ~ \(self.endIndex)")
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
                    let filteredAuction = dailyAuction.filter({ ($0["AVGPRICE"] as? Float) != 0.0 })
                    filteredAuction.forEach{
                        auctions.append(DailyAuctionResponse(auctionDictionary: $0))
                    }
                }
                self.dailyAuctionData.append(contentsOf: auctions)
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
        if self.isSearchView {
            // 검색 cell
            if searchData.count == 0 {
                defaultView.isHidden = false
            }
            else {
                defaultView.isHidden = true
            }
            return searchData.count
        }
        else {
            if dailyAuctionData.count == 0 {
                defaultView.isHidden = false
            }
            else {
                defaultView.isHidden = true
            }
            return dailyAuctionData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let auctionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyAuctionCell", for: indexPath) as? DailyAuctionCollectionViewCell else {
            return UICollectionViewCell()
        }
        if self.isSearchView {
            // 검색 cell
            auctionCell.generateCell(dailyAuction:searchData[indexPath.item])
        }
        else {
            auctionCell.generateCell(dailyAuction:dailyAuctionData[indexPath.item])
        }
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
        print(dailyAuctionData)
        guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailInfoViewController else { return }
        // 화면 전환 애니메이션 설정
        detailVC.modalTransitionStyle = .coverVertical
        // 전환된 화면이 보여지는 방법 설정 (fullScreen)
        var detailData = dailyAuctionData[indexPath.row]
        detailVC.getDetailData(detailData: detailData)
        
        detailVC.modalPresentationStyle = .fullScreen
        self.present(detailVC, animated: true, completion: nil)
    }
}
