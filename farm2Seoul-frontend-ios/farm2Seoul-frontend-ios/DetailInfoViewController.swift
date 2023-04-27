//
//  DetailInfoBoardViewController.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/18.
//

import UIKit
import Alamofire
//import Charts

class DetailInfoViewController: UIViewController {
    
    @IBOutlet weak var navTitle: UINavigationItem!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var rankImage: UIImageView!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var averagePriceLabel: UILabel!
    @IBOutlet weak var maximumPriceLabel: UILabel!
    @IBOutlet weak var minimumPriceLabel: UILabel!
    @IBOutlet weak var thisWeekButton: UIButton!
    @IBOutlet weak var lastFourWeeksButton: UIButton!
    @IBOutlet weak var lastThreeMonthsButton: UIButton!
    @IBOutlet weak var graphView: UIView!
    
    var productName: String = ""
    var rank: String = ""
    var weight: String = ""
    var avrPrice: String = ""
    var maxPrice: String = ""
    var minPrice: String = ""
    var unit: String = ""
    var dataOfChart: [Double] = []
    var quantity: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDetailView()
        makeButton()
        
//        getThisWeekGraphData()
    }
    
    func getDetailData(detailData: DailyAuctionResponse) {
        self.productName = detailData.name
        self.rank = detailData.rank
        self.weight = detailData.weight
        self.avrPrice = String(detailData.avrPrice)
        self.maxPrice = String(detailData.maxPrice)
        self.minPrice = String(detailData.minPrice)
        
        (self.quantity, self.unit) = separateNumberAndUnit(from: self.weight) ?? (0.0, "")
    }
    
    func makeDetailView(){
        productNameLabel.text = self.productName
        weightLabel.text = self.weight
        
        let fontSize = UIFont.boldSystemFont(ofSize: 12) // Change the font size here
        
        var fullText = self.avrPrice + "원"
        var attributedString = NSMutableAttributedString(string: fullText)
        var range = (fullText as NSString).range(of: "원")
        attributedString.addAttribute(.font, value: fontSize, range: range)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: range)
        averagePriceLabel.attributedText = attributedString
        
        fullText = self.maxPrice + "원"
        attributedString = NSMutableAttributedString(string: fullText)
        range = (fullText as NSString).range(of: "원")
        attributedString.addAttribute(.font, value: fontSize, range: range)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: range)
        maximumPriceLabel.attributedText = attributedString
        
        
        fullText = self.minPrice + "원"
        attributedString = NSMutableAttributedString(string: fullText)
        range = (fullText as NSString).range(of: "원")
        attributedString.addAttribute(.font, value: fontSize, range: range)
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: range)
        minimumPriceLabel.attributedText = attributedString
        
        switch self.rank {
        case "특":
            return rankImage.image = UIImage(named: "SpecialRankImage")
        case "상":
            return rankImage.image = UIImage(named: "HighRankImage")
        case "중":
            return rankImage.image = UIImage(named: "MiddleRankImage")
        case "하":
            return rankImage.image = UIImage(named: "LowRankImage")
        default:
            return rankImage.image = UIImage(named: "LowRankImage")
        }
    }
    
    func makeButton(){
        thisWeekButton.setTitle("이번주 가격변동", for: .normal)
        thisWeekButton.backgroundColor = UIColor(named: "MainColor")
        thisWeekButton.layer.cornerRadius = 20
        thisWeekButton.clipsToBounds = true
        thisWeekButton.setTitleColor(UIColor.white, for: .normal)
        
        lastFourWeeksButton.setTitle("최근 4주간", for: .normal)
        lastFourWeeksButton.backgroundColor = UIColor(named: "GraphButtonColor")
        lastFourWeeksButton.layer.cornerRadius = 20
        lastFourWeeksButton.clipsToBounds = true
        lastFourWeeksButton.setTitleColor(UIColor.white, for: .normal)
        
        lastThreeMonthsButton.setTitle("최근 3개월간", for: .normal)
        lastThreeMonthsButton.backgroundColor = UIColor(named: "GraphButtonColor")
        lastThreeMonthsButton.layer.cornerRadius = 20
        lastThreeMonthsButton.clipsToBounds = true
        lastThreeMonthsButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    @IBAction func thisWeekButtonTapped(_ sender: UIButton) {
        thisWeekButton.backgroundColor = UIColor(named: "MainColor")
        lastFourWeeksButton.backgroundColor = UIColor(named: "GraphButtonColor")
        lastThreeMonthsButton.backgroundColor = UIColor(named: "GraphButtonColor")
        sender.isSelected = true
        lastFourWeeksButton.isSelected = false
        lastThreeMonthsButton.isSelected = false
        
        print("\(thisWeekButton.isSelected) + \(lastFourWeeksButton.isSelected) + \(lastThreeMonthsButton.isSelected)")
        getThisWeekGraphData()
    }
    
    @IBAction func lastFourWeeksButtonTapped(_ sender: UIButton) {
        
        lastFourWeeksButton.backgroundColor = UIColor(named: "MainColor")
        thisWeekButton.backgroundColor = UIColor(named: "GraphButtonColor")
        lastThreeMonthsButton.backgroundColor = UIColor(named: "GraphButtonColor")
        sender.isSelected = true
        thisWeekButton.isSelected = false
        lastThreeMonthsButton.isSelected = false
        
        print("\(thisWeekButton.isSelected) + \(lastFourWeeksButton.isSelected) + \(lastThreeMonthsButton.isSelected)")

        getLastFourWeeksGraphData()
    }
    
    @IBAction func lastThreeMonthsButtonTapped(_ sender: UIButton) {
        print("lastThreeMonthsButton \(lastThreeMonthsButton.isSelected)")
        lastThreeMonthsButton.backgroundColor = UIColor(named: "MainColor")
        thisWeekButton.backgroundColor = UIColor(named: "GraphButtonColor")
        lastFourWeeksButton.backgroundColor = UIColor(named: "GraphButtonColor")
        sender.isSelected = true
        lastFourWeeksButton.isSelected = false
        thisWeekButton.isSelected = false
        
        print("\(thisWeekButton.isSelected) + \(lastFourWeeksButton.isSelected) + \(lastThreeMonthsButton.isSelected)")
        getLastThreeMonthsGraphData()
    }
    
    func getThisWeekGraphData(){
        
        let path = "http://high-school-fish.com:8081/api/v1/auctions/this-week?name=\(self.productName)&grade=\(self.rank)&quantity=\(self.quantity)&unit=\(self.unit)"
        
        print("path: \(path)")
        guard let encodedStr = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        let url = URL(string: encodedStr)!
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url,method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseJSON { (response) in
            let result = response.result
            var thisWeekGraphData = [ThisWeekResponse]()
            switch result {
            case .success(let value as [String: Any]):
                print("통신성공")
                print(value)
                
                // value 디코딩해야함 -> ThisWeekResponse
//                let thisWeekResponse = try? JSONDecoder().decode(ThisWeekResponse.self, from: response.data)

                if let data = value as? [Dictionary<String, AnyObject>] {
                    print(data.count)
                    data.forEach {
                        thisWeekGraphData.append(ThisWeekResponse(thisWeekDictionary: $0))
                    }
                }
                
                print("thisWeek count \(thisWeekGraphData.count)")
                      
            case .failure(let error):
                print(error.localizedDescription)
                
            default:
                fatalError()
            }
        }
    }
    
    func getLastFourWeeksGraphData(){
        let path = "http://high-school-fish.com:8081/api/v1/auctions/unit/average-prices/last-4-weeks?name=\(self.productName)&grade=\(self.rank)&quantity=\(self.quantity)&unit=\(self.unit)"

        print("path: \(path)")
        guard let encodedStr = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        let url = URL(string: encodedStr)!
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url,method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseJSON { (response) in
            let result = response.result
            var thisWeekGraphData = [ThisWeekResponse]()
            switch result {
            case .success(let value as [String: Any]):
                print("통신성공")
                print(value)
                
                // value 디코딩해야함 -> ThisWeekResponse
//                let thisWeekResponse = try? JSONDecoder().decode(ThisWeekResponse.self, from: response.data)

                if let data = value as? [Dictionary<String, AnyObject>] {
                    print(data.count)
                    data.forEach {
                        thisWeekGraphData.append(ThisWeekResponse(thisWeekDictionary: $0))
                    }
                }
                
                print("thisWeek count \(thisWeekGraphData.count)")
                      
            case .failure(let error):
                print(error.localizedDescription)
                
            default:
                fatalError()
            }
        }
    }
    
    func getLastThreeMonthsGraphData(){
        let path = "http://high-school-fish.com:8081/api/v1/auctions/average-prices/last-3-month?name=\(self.productName)&grade=\(self.rank)&quantity=\(self.quantity)&unit=\(self.unit)"
        
        print("path: \(path)")
        guard let encodedStr = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }

        let url = URL(string: encodedStr)!
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url,method: .get,
                   parameters: nil,
                   encoding: URLEncoding.default,
                   headers: header)
        .validate(statusCode: 200..<300)
        .responseJSON { (response) in
            let result = response.result
            var thisWeekGraphData = [ThisWeekResponse]()
            switch result {
            case .success(let value as [String: Any]):
                print("통신성공")
                print(value)
                
                // value 디코딩해야함 -> ThisWeekResponse
//                let thisWeekResponse = try? JSONDecoder().decode(ThisWeekResponse.self, from: response.data)

                if let data = value as? [Dictionary<String, AnyObject>] {
                    print(data.count)
                    data.forEach {
                        thisWeekGraphData.append(ThisWeekResponse(thisWeekDictionary: $0))
                    }
                }
                
                print("thisWeek count \(thisWeekGraphData.count)")
                      
            case .failure(let error):
                print(error.localizedDescription)
                
            default:
                fatalError()
            }
        }
    }
    
    func separateNumberAndUnit(from string: String) -> (Double, String)? {
        let pattern = #"^(\d+(?:\.\d+)?)(\D+)$"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        let range = NSRange(location: 0, length: string.utf16.count)
        if let match = regex.firstMatch(in: string, options: [], range: range) {
            let numberRange = match.range(at: 1)
            let unitRange = match.range(at: 2)
            let numberString = (string as NSString).substring(with: numberRange)
            let unitString = (string as NSString).substring(with: unitRange)
            if let number = Double(numberString) {
                return (number, unitString)
            }
        }

        return nil
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        backAction()
    }
    
    @objc func backAction() {
        dismiss(animated: true, completion: nil)
    }
}
