//
//  ViewController.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/18.
//

import UIKit
import Tabman
import Pageboy
import Alamofire

class MainTabViewController: TabmanViewController, UITextFieldDelegate{
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchImageButton: UIButton!
    
    var searchData:[DailyAuctionResponse] = []
    var searchText: String = "test message"
    var myVariable: String = "Hello, world!"
    var myBar: TMBar?
    
    private var viewControllers: [UIViewController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        isScrollEnabled = false
        print("MainTabVC viewDidLoad")
        // Do any additional setup after loading the view.
        //        self.searchTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: .editingChanged)
        searchTextField.delegate = self
        makeTabBarView()
        myBar?.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("MainTabVC viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("MainTabVC viewDidlAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("MainTabVC viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("MainTabVC viewDidDisappear")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // TextField 비활성화
        //        self.view.endEditing(true)
        // 버튼 누른 효과 줘야함
        return true
    }
    
    @IBAction func textFieldDidChange(_sender: UITextField) {
        print("tf DidChange")
        
        if searchTextField.text == ""{
            if let dailyAuctionVC = self.viewControllers.first as? DailyAuctionViewController {
                dailyAuctionVC.isSearchView = false
                dailyAuctionVC.dailyAuctionCollectionView.reloadData()
            }
        }
    }
    
    //    // 입력이 시작되면 호출 (시점)
    @IBAction func textFieldDidBeginEditing(_ textField: UITextField){
        print("tf beginEditing")
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func makeTabBarView(){
        let dailyAuctionVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DailyAuctionVC") as! DailyAuctionViewController
        let infoBoardVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InfoBoardVC") as! InfoBoardViewController
        let bookmarkVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookmarkVC") as! BookmarkViewController
        
        viewControllers.append(dailyAuctionVC)
        viewControllers.append(infoBoardVC)
        viewControllers.append(bookmarkVC)
        
        self.dataSource = self
        
        dailyAuctionVC.completionHandler = {text in
            print(text)
            self.view.endEditing(true)
        }
        infoBoardVC.completionHandler = {text in
            print(text)
            self.view.endEditing(true)
        }
        bookmarkVC.completionHandler = {text in
            print(text)
            self.view.endEditing(true)
        }
        
        let bar = TMBar.TabBar()
        
        //탭바 레이아웃 설정
        bar.layout.transitionStyle = .snap
        bar.layout.alignment = .centerDistributed
        
        //배경색
        bar.backgroundView.style = .clear
        bar.backgroundColor = .white
        
        //버튼 글씨 커스텀
        bar.buttons.customize{ (button) in
            button.tintColor = UIColor(named: "TabBarTextColor")
            button.selectedTintColor = UIColor(named: "MainColor")
        }
        bar.indicator.overscrollBehavior = .bounce
        bar.indicator.tintColor = UIColor(named: "MainColor")
        
        addBar(bar, dataSource: self, at: .custom(view: tabView, layout: nil))
    }
    
    @IBAction func searchButtonTapped(_ sender: UIButton){
        // vc[0]으로 화면 전환해야함
        print("searchButtonTapped")
        
        self.view.endEditing(true)
        
        if let dailyAuctionVC = self.viewControllers.first as? DailyAuctionViewController {
            print("searchButtonTapped vc first")

            if searchTextField.text?.count == 1 {
                if searchTextField.text?.first == " " {
                    print("text first")
                    searchTextField.text = ""
                    dailyAuctionVC.isSearchView = false
                    dailyAuctionVC.dailyAuctionCollectionView.reloadData()
                    return
                }
            }
            if searchTextField.text == ""{
                print("text empty")

                dailyAuctionVC.isSearchView = false
                dailyAuctionVC.dailyAuctionCollectionView.reloadData()
                return
            }
            
            print("productName1 \(searchTextField.text!)")
            getDailyAuction(startIndex: 1, endIndex: 500, productName: searchTextField.text!)
            
        }
        scrollToPage(.at(index: 0), animated: true, completion: nil)

    }
    
    func getDailyAuction(startIndex: Int, endIndex: Int, productName: String) {
        print("productName2 \(productName)")
        if let dailyAuctionVC = self.viewControllers.first as? DailyAuctionViewController {
            dailyAuctionVC.searchData.removeAll()
            self.searchData.removeAll()
            print("dailyvc count2 \(dailyAuctionVC.dailyAuctionData.count)")
            
            print("productName : \(productName)")
            let authKey = "766c476c676b6e793132345770716c57"
            let requestType = "json"
            let serviceName = "GarakGradePrice"
            let path = "http://openapi.seoul.go.kr:8088/\(authKey)/\(requestType)/\(serviceName)/\(startIndex)/\(endIndex)/\(productName)"
            guard let encodedStr = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            
            print("\(startIndex) ~ \(endIndex)")
            let url = URL(string: encodedStr)!
            let header : HTTPHeaders = ["Content-Type": "application/json"]
            
            AF.request(url).responseJSON { (response) in
                let result = response.result
                var auctions = [DailyAuctionResponse]()
                print("auctions count0 \(auctions.count)")
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
                    self.searchData.append(contentsOf: auctions)
                    print("auctions count1 \(auctions.count)")
                    print("search count1 \(self.searchData.count)")
                    
                    print("search count1 \(self.searchData.count)")
                    
                    dailyAuctionVC.searchData = self.searchData
                    dailyAuctionVC.isSearchView = true
                    dailyAuctionVC.dailyAuctionCollectionView.reloadData()
                    print("dailyvc count2 \(dailyAuctionVC.dailyAuctionData.count)")
                    
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    
                default:
                    fatalError()
                }
                
            }
        }
        
    }
    override func bar(_ bar: TMBar, didRequestScrollTo index: Int) {
        scrollToPage(.at(index: index), animated: true, completion: nil)
    }
}

extension MainTabViewController: PageboyViewControllerDataSource, TMBarDataSource {
    
    
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        switch index {
        case 0:
            let item = TMBarItem(title: "일별경매")
            item.image = UIImage(named: "DailyAuctionTabIcon")
            item.selectedImage = UIImage(named: "DailyAuctionTappedIcon")
            return item
        case 1:
            let item = TMBarItem(title: "정보마당")
            item.image = UIImage(named: "InfoBoardTabIcon")
            item.selectedImage = UIImage(named: "InfoBoardTappedIcon")
            return item
        case 2:
            let item = TMBarItem(title: "즐겨찾기")
            item.image = UIImage(named: "BookmarkTabIcon")
            item.selectedImage = UIImage(named: "BookmarkTappedIcon")
            return item
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
    
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }
    
    func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
        print("test \(index)")
        self.searchTextField.text = ""
        self.view?.endEditing(true)
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }
    
    
}
