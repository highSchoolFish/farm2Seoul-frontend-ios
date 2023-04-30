//
//  DetailInfoBoardViewController.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/18.
//

import UIKit
import Alamofire
import Charts

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
    @IBOutlet weak var lineChartView: LineChartView!
    
    var numberOfChart: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
    var dayOfChart: [String] = ["월", "화", "수", "목", "금", "토"]
    var averagePrice: [Double] = [0.0, 0.0, 0.0, 0.0]
    var weeksData: [String] = ["1주전", "2주전", "3주전", "4주전"]
    
    var productName: String = ""
    var rank: String = ""
    var weight: String = ""
    var avrPrice: String = ""
    var maxPrice: String = ""
    var minPrice: String = ""
    var unit: String = ""
    var dataOfChart: [Double] = []
    var quantity: String = ""
    var lineChartEntry = [ChartDataEntry]() // graph 에 보여줄 data array
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDetailView()
        makeButton()
        makeGraphView()
        getCurrentDateTime()
    }
    
    func getCurrentDateTime(){
        let formatter = DateFormatter() //객체 생성
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy. MM. dd" //데이터 포멧 설정
        let str = formatter.string(from: Date()) //문자열로 바꾸기
        navTitle.title = "\(str)"   //라벨에 출력
    }
    
    func makeGraphView() {
        initChart(chart: self.lineChartView)
        getThisWeekGraphData()
        
    }
    
    func initChart(chart: LineChartView) {
        chart.backgroundColor = UIColor(named: "GraphViewBackgroundColor")
        chart.noDataText = "경매 정보가 없습니다."
        chart.noDataFont = .systemFont(ofSize: 20)
        chart.noDataTextColor = .gray
        chart.dragEnabled = false
        chart.drawGridBackgroundEnabled = false
        chart.isMultipleTouchEnabled = false
        chart.scaleXEnabled = false
        chart.scaleYEnabled = false
        //        chart.autoScaleMinMaxEnabled = true
        chart.chartDescription?.text = "(평균가 기준)"
        chart.xAxis.enabled = true
        chart.xAxis.drawAxisLineEnabled = false
        chart.xAxis.drawGridLinesEnabled = true
        chart.xAxis.labelPosition = .bottom
        chart.xAxis.granularity = 1.0
        
        // 배열 값의 최대 최소 값 받아서 다이나믹하게 그리기
        chart.leftAxis.axisMinimum = 0.0
        //        chart.leftAxis.axisMaximum = 최대
        
        chart.leftAxis.granularity = 1.0
        
        chart.leftAxis.enabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.leftAxis.drawLabelsEnabled = false
        
        chart.rightAxis.drawAxisLineEnabled = false
        chart.rightAxis.drawGridLinesEnabled = false
        chart.rightAxis.drawLabelsEnabled = false
        
    }
    
    // entry 만들기
    func entryData(values: [Double]) -> [ChartDataEntry] {
        // entry 담을 array
        var lineDataEntries: [ChartDataEntry] = []
        // 담기
        for i in 0 ..< values.count {
            let lineDataEntry = ChartDataEntry(x: Double(i), y: values[i])
            lineDataEntries.append(lineDataEntry)
        }
        // 반환
        return lineDataEntries
    }
    
    // 데이터 적용하기
    func setLineData(lineChartView: LineChartView, lineChartDataEntries: [ChartDataEntry]) {
        // Entry들을 이용해 Data Set 만들기
        let lineChartdataSet = LineChartDataSet(entries: lineChartDataEntries, label: "가격")
        let mainColor = UIColor(named:"MainColor")
        lineChartdataSet.colors = [NSUIColor(cgColor: mainColor!.cgColor)]
        lineChartdataSet.setCircleColor(NSUIColor(cgColor: mainColor!.cgColor))
        lineChartdataSet.lineWidth = 3
        lineChartdataSet.circleRadius = 5
        lineChartdataSet.circleHoleRadius = 3
        
        // DataSet을 차트 데이터로 넣기
        let lineChartData = LineChartData(dataSet: lineChartdataSet)
        // 데이터 출력
        
        lineChartView.data = lineChartData
        
    }
    
    func getDetailData(detailData: DailyAuctionResponse) {
        self.productName = detailData.name
        self.rank = detailData.rank
        self.weight = detailData.weight
        self.avrPrice = String(detailData.avrPrice)
        self.maxPrice = String(detailData.maxPrice)
        self.minPrice = String(detailData.minPrice)
        
        (self.quantity, self.unit) = separateNumberAndUnit(from: self.weight) ?? ("0.00", "")
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
        thisWeekButton.isEnabled = false
        
        lastFourWeeksButton.setTitle("최근 4주간", for: .normal)
        lastFourWeeksButton.backgroundColor = UIColor(named: "GraphButtonColor")
        lastFourWeeksButton.layer.cornerRadius = 20
        lastFourWeeksButton.clipsToBounds = true
        lastFourWeeksButton.setTitleColor(UIColor.black, for: .normal)
        
        lastThreeMonthsButton.setTitle("최근 3개월간", for: .normal)
        lastThreeMonthsButton.backgroundColor = UIColor(named: "GraphButtonColor")
        lastThreeMonthsButton.layer.cornerRadius = 20
        lastThreeMonthsButton.clipsToBounds = true
        lastThreeMonthsButton.setTitleColor(UIColor.black, for: .normal)
    }
    
    
    @IBAction func thisWeekButtonTapped(_ sender: UIButton) {
        numberOfChart = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
                thisWeekButton.backgroundColor = UIColor(named: "MainColor")
                lastFourWeeksButton.backgroundColor = UIColor(named: "GraphButtonColor")
                lastThreeMonthsButton.backgroundColor = UIColor(named: "GraphButtonColor")
                thisWeekButton.setTitleColor(UIColor.white, for: .normal)
                lastThreeMonthsButton.setTitleColor(UIColor.black, for: .normal)
                lastFourWeeksButton.setTitleColor(UIColor.black, for: .normal)

                getThisWeekGraphData()
                thisWeekButton.isEnabled = false
                lastFourWeeksButton.isEnabled = true
                lastThreeMonthsButton.isEnabled = true

    }
    
    @IBAction func lastFourWeeksButtonTapped(_ sender: UIButton) {
        averagePrice = [0.0, 0.0, 0.0, 0.0]
                lastFourWeeksButton.backgroundColor = UIColor(named: "MainColor")
                thisWeekButton.backgroundColor = UIColor(named: "GraphButtonColor")
                lastThreeMonthsButton.backgroundColor = UIColor(named: "GraphButtonColor")
                thisWeekButton.setTitleColor(UIColor.black, for: .normal)
                lastThreeMonthsButton.setTitleColor(UIColor.black, for: .normal)
                lastFourWeeksButton.setTitleColor(UIColor.white, for: .normal)
                getLastFourWeeksGraphData()
                thisWeekButton.isEnabled = true
                lastFourWeeksButton.isEnabled = false
                lastThreeMonthsButton.isEnabled = true
    }
    
    @IBAction func lastThreeMonthsButtonTapped(_ sender: UIButton) {
//        numberOfChart = [0.0, 0.0, 0.0]
                print("lastThreeMonthsButton \(lastThreeMonthsButton.isSelected)")
                lastThreeMonthsButton.backgroundColor = UIColor(named: "MainColor")
                thisWeekButton.backgroundColor = UIColor(named: "GraphButtonColor")
                lastFourWeeksButton.backgroundColor = UIColor(named: "GraphButtonColor")
                
                thisWeekButton.setTitleColor(UIColor.black, for: .normal)
                lastThreeMonthsButton.setTitleColor(UIColor.white, for: .normal)
                lastFourWeeksButton.setTitleColor(UIColor.black, for: .normal)
                
        //        getLastThreeMonthsGraphData()
                thisWeekButton.isEnabled = true
                lastFourWeeksButton.isEnabled = true
                lastThreeMonthsButton.isEnabled = false
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
                case .success(let value):
                    print("통신성공")
                    print(value)
                    if let data = value as? [[String: Any]] {
                        for dict in data {
                            print(dict["dayOfWeek"]!)
                            if dict["dayOfWeek"] as! String == "월" {
                                self.numberOfChart[0] = dict["average"] as! Double
                            }
                            if dict["dayOfWeek"] as! String == "화" {
                                self.numberOfChart[1] = dict["average"] as! Double
                            }
                            if dict["dayOfWeek"] as! String == "수" {
                                self.numberOfChart[2] = dict["average"] as! Double
                            }
                            if dict["dayOfWeek"] as! String == "목" {
                                self.numberOfChart[3] = dict["average"] as! Double
                            }
                            if dict["dayOfWeek"] as! String == "금" {
                                self.numberOfChart[4] = dict["average"] as! Double
                            }
                            if dict["dayOfWeek"] as! String == "토" {
                                self.numberOfChart[5] = dict["average"] as! Double
                            }
                        }
                    }
                    print(self.dayOfChart)
                    print(self.numberOfChart)

                    self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.dayOfChart)

                    self.setLineData(lineChartView: self.lineChartView, lineChartDataEntries: self.entryData(values: self.numberOfChart))

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
                var lastFourWeeksGraphData = [LastFourWeeksResponse]()
                switch result {
                case .success(let value):
                    print("통신성공")
                    print(value)
                
                    if let data = value as? [[String: Any]] {
                        for dict in data {
                            print(dict["weekName"]!)
                            if dict["weekName"] as! String == "1주전" {
                                self.averagePrice[0] = dict["averagePrice"] as! Double
                            }
                            if dict["weekName"] as! String == "2주전" {
                                self.averagePrice[1] = dict["averagePrice"] as! Double
                            }
                            if dict["weekName"] as! String == "3주전" {
                                self.averagePrice[2] = dict["averagePrice"] as! Double
                            }
                            if dict["weekName"] as! String == "4주전" {
                                self.averagePrice[3] = dict["averagePrice"] as! Double
                            }
                        }
                    }
                    print(self.weeksData)
                    print(self.averagePrice)
                    self.lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: self.weeksData)

                                    
                    self.setLineData(lineChartView: self.lineChartView, lineChartDataEntries: self.entryData(values: self.averagePrice))

                    case .failure(let error):
                    print(error.localizedDescription)
                    
                default:
                    fatalError()
                }
            }
        }

    
//    func getLastThreeMonthsGraphData(){
//        let path = "http://high-school-fish.com:8081/api/v1/auctions/average-prices/last-3-month?name=\(self.productName)&grade=\(self.rank)&quantity=\(self.quantity)&unit=\(self.unit)"
//
//        print("path: \(path)")
//        guard let encodedStr = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
//
//        let url = URL(string: encodedStr)!
//        let header : HTTPHeaders = ["Content-Type": "application/json"]
//
//        AF.request(url,method: .get,
//                   parameters: nil,
//                   encoding: URLEncoding.default,
//                   headers: header)
//        .validate(statusCode: 200..<300)
//        .responseJSON { (response) in
//            let result = response.result
//            var thisWeekGraphData = [ThisWeekResponse]()
//            switch result {
//            case .success(let value as [String: Any]):
//                print("통신성공")
//                print(value)
//
//                // value 디코딩해야함 -> ThisWeekResponse
//                //                let thisWeekResponse = try? JSONDecoder().decode(ThisWeekResponse.self, from: response.data)
//
//                if let data = value as? [Dictionary<String, AnyObject>] {
//                    print(data.count)
//                    data.forEach {
//                        thisWeekGraphData.append(ThisWeekResponse(thisWeekDictionary: $0))
//                    }
//                }
//
//                print("thisWeek count \(thisWeekGraphData.count)")
//
//            case .failure(let error):
//                print(error.localizedDescription)
//
//            default:
//                fatalError()
//            }
//        }
//    }
    
    func separateNumberAndUnit(from string: String) -> (String, String)? {
        let pattern = #"^(\d+(?:\.\d+)?)(\D+)$"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        
        let range = NSRange(location: 0, length: string.utf16.count)
        if let match = regex.firstMatch(in: string, options: [], range: range) {
            let numberRange = match.range(at: 1)
            let unitRange = match.range(at: 2)
            let numberString = (string as NSString).substring(with: numberRange)
            let unitString = (string as NSString).substring(with: unitRange)
            if let number = Double(numberString) {
                let formattedString = String(format: "%.2f", number)
                return (formattedString, unitString)
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
