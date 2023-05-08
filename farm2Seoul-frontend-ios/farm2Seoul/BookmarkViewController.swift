//
//  BookmarkViewController.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/18.
//

import UIKit
import CoreData
import Alamofire

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var initView: UIView!
    
    @IBOutlet var bookmarkCollectionView: UICollectionView!
    @IBOutlet var bookmarkDetailCollectionView: UICollectionView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var defaultView: UIView!
    
    let interval = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    var productBookmarkedData: [NSManagedObject] {
        return self.fetch()
    }
    var selectedItems = [IndexPath]()
    var bookmarkedStringArr: [String] = []
    var showData: [String] = []
    var tempSave: [String] = []
    var tempDelete: [String] = []
    var detailData: [DailyAuctionResponse] = []
    var productAllData:[String] = ["(냉)갈치", "(냉)고등어", "(냉)고등어수입", "(선)갈치", "(선)고등어", "(선)명태수입", "가리비", "가무락(모시조개)", "가시오이", "가오리수입", "가자미", "가지", "갈치수입", "감대봉시", "감말랭이", "감약시", "감귤", "감귤극조생", "감귤금귤", "감귤비가림", "감귤온주", "감귤하우스", "감숭어", "감자", "감자대지마", "감자두백", "감자수미", "감자수미(저장)", "감자수미(햇)", "감자수입", "갑오징어", "갯장어", "건고구마순수입", "건꼴뚜기", "건대멸치", "건미역대각", "건세멸치", "건소멸치", "건오징어근해", "건자멸치", "건중멸치", "건토란대수입", "건파래", "겉홍합", "겨자잎", "고구마", "고구마풍원미", "고수", "골드파인애플수입", "곰취나물", "곶감국산", "굴", "그린빈스", "그린키위국산", "근대", "김개량", "김재래", "깐바지락", "깐쪽파", "깻잎", "꽃게수입", "꽃게수", "꽃게암", "꽃느타리버섯", "꽈리고추", "낙지수입", "냉동가자미수입", "냉동꽁치", "냉동낙지", "냉동낙지수입", "냉동오징어(연안)", "냉동오징어(원양)", "냉동조기수입", "냉동주꾸미수입", "냉이", "냉이수입", "냉태원양", "노각오이", "노랑파프리카", "녹광고추", "논우렁", "느타리버섯", "늙은호박", "다발무", "다시마", "단감부유", "단감상서", "단감서촌", "단감송본", "단호박수입", "단호박(일반)", "달래(일반)", "당귀잎", "당근", "당근수입", "대구", "대구냉장수입", "대구수입", "대파수입", "대파(일반)", "대합", "도루묵", "돗나물", "동죽", "둥근애호박", "딸기", "딸기금실", "딸기설향", "딸기육보", "딸기장희", "딸기죽향", "땅두릅(재배산)", "땅콩수입", "레드치커리", "레몬수입", "로메인(일반)", "로케트루꼴라", "롱그린고추", "마늘쫑", "만가닥버섯", "만감레드향", "만감천혜향", "만감한라봉", "만감황금향", "맛", "망고국산", "매생이(일반)", "머위대", "멍게", "메론머스크", "메론파파야", "명태피포", "모과", "몽키바나나수입", "무", "무순", "무화과국산", "문어", "물오징어", "미나리", "미더덕", "민어", "바나나수입", "바실", "바지락", "바지락수입", "반청갓", "방풍나물", "배신고", "배원황", "배추", "배추얼갈이", "백다다기오이", "백색메론", "백조기", "뱅어포", "병어", "복분자(일반)", "복수박", "복숭아가납암", "복숭아경봉", "복숭아그레이트", "복숭아레드골드", "복숭아미백", "복숭아백도기타", "복숭아백봉", "복숭아사자", "복숭아선광", "복숭아선프레", "복숭아신비", "복숭아신선", "복숭아아부백도", "복숭아암킹", "복숭아애천중도", "복숭아엘버트", "복숭아올인", "복숭아월미", "복숭아월봉", "복숭아유명백도", "복숭아창방", "복숭아천도기타", "복숭아천중도백도", "복숭아천홍", "복숭아호기도", "복숭아환타지아", "복숭아황도기타", "봄동배추", "봉지미역", "봉지바지락", "부세수입", "부추(일반)", "북어대태", "북어채", "브로콜리", "브로콜리국산", "브로콜리수입", "블루베리국산", "블루베리수입", "비름", "비타민", "비트", "비트국산", "빨간양배추국산", "빨간양배추수입", "빨강파프리카", "사과감홍", "사과로얄부사", "사과미시마", "사과미야비", "사과미얀마", "사과부사", "사과시나노레드", "사과시나노스위트", "사과아오리", "사과양광", "사과요까", "사과홍로", "사과홍옥", "사과홍장군", "사과히로사끼", "사과대추", "산딸기국산", "살구개량", "삼치", "상추", "상추적포기", "상추포기찹", "새꼬막", "새송이버섯", "새우수입", "새조개", "생강구강", "생강원강", "생강재강", "생대추", "생취나물", "생표고", "생표고수입", "　석류수입", "셀러리", "소라", "수박", "수박(일반)", "수삼5년근", "시금치", "시금치섬초", "시금치포항초", "실파", "쌈배추", "쑥", "쑥(일반)", "쑥갓", "씀바귀", "아귀냉장수입", "아귀(일반)", "아로니아국산", "아보카도수입", "아스파라가스국산", "아욱", "알배기배추", "애호박", "앵두국산", "양배추", "양배추수입", "양상추", "양상추수입", "양상추(일반)", "양송이", "양파", "양파수입", "양파조생", "양파(햇)", "연근(일반)", "열무", "염장다시마", "영양부추", "오디국산", "오렌지네블수입", "오렌지발렌샤수입", "오렌지파프리카", "오만둥이", "오이맛고추", "완두콩", "유자", "육쪽마늘", "임연수어", "임연수어수입", "잉어", "자두대석", "자두정상", "자두추희", "자두후무사", "자몽수입", "자주양파", "저장양파", "적겨자잎", "적근대", "적로메인", "적상추", "적어수입", "전어", "절임배추", "주꾸미", "주꾸미수입", "죽순국산", "중하", "쥬키니호박", "쪽파(일반)", "쫑상추", "찰옥수수", "참나물", "참두릅(자연산)", "참숭어", "참외(일반)", "참조기", "청갓", "청경채", "청매실", "청상추", "청양고추", "청어", "청초", "청피망", "체리국산", "취나물", "취청오이", "치커리(일반)", "칼리플라워", "케일", "코다리명태", "콜라비(일반)", "키위기타수입", "토마토", "토마토대저", "토마토대추방울", "토마토방울", "토마토완숙", "통로메인파세리", "파인애플수입", "팽이버섯", "포도거봉", "포도네오머스켓", "포도델라웨어", "포도마스컷(MBA)", "포도샤인머스켓", "포도수입", "포도청포도", "포도캠벨얼리", "풋고추(일반)", "피뿔고동(소라)", "피조개", "해삼", "햇마늘난지", "햇마늘남도", "햇마늘대서", "햇마늘한지", "호박고구마", "호박밤고구마", "홍감자", "홍게", "홍고추", "홍어수입", "홍자두", "홍피망", "홍합살", "활넙치(양식)", "활넙치(자연)", "활노래미(자연)", "활농어수입", "활농어(자연)", "활돔(양식)", "활돔(자연)", "활미꾸라지(양식)", "활민어(자연)", "활방어(자연)", "활우럭(양식)", "활우럭(자연)", "활전복(양식)", "활전어(자연)", "활점성어수입", "활꽃게수", "활꽃게암", "활낙지수입", "활도다리(자연)", "활메기(양식)", "활민물장어(양식)", "황색메론"]
    
    var bookmarkArr: [NSLayoutManager]?
    var completionHandler: ((String) -> ())?
    
    // persistentContainer로 접근하기 위한 NSManagedObjectContext를 생성
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(productBookmarkedData)
        defaultView.isHidden = true
        bookmarkCollectionView.allowsMultipleSelection = true
        
        self.bookmarkCollectionView.register(UINib(nibName: "BookmarkCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "bookmarkCell")
        self.bookmarkCollectionView.dataSource = self
        self.bookmarkCollectionView.delegate = self
        
        self.bookmarkDetailCollectionView.register(UINib(nibName: "DailyAuctionCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "DailyAuctionCell")
        
        cancelButton.layer.cornerRadius = 5
        cancelButton.clipsToBounds = true
        cancelButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        cancelButton.layer.shadowOpacity = 0.5
        cancelButton.layer.shadowRadius = 2
        cancelButton.layer.masksToBounds = false
        
        saveButton.layer.cornerRadius = 5
        saveButton.clipsToBounds = true
        saveButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        saveButton.layer.shadowOpacity = 0.5
        saveButton.layer.shadowRadius = 2
        saveButton.layer.masksToBounds = false
        
        addButton.layer.cornerRadius = 5
        addButton.clipsToBounds = true
        addButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        addButton.layer.shadowOpacity = 0.5
        addButton.layer.shadowRadius = 2
        addButton.layer.masksToBounds = false
        
        addView.isHidden = true
        detailView.isHidden = true
        
        // delete all data
//        for managedObject in productBookmarkedData {
//            let string = managedObject.value(forKey: "productName") as? String ?? ""
//            deleteCoreData(productName: string)
//        }
        //
        // init
        for managedObject in productBookmarkedData {
            let string = managedObject.value(forKey: "productName") as? String ?? ""
            self.bookmarkedStringArr.append(string)
            showData.append(string)
        }
        print("VDL bookmarkedStringArr \(bookmarkedStringArr)")
        print("VDL selectedItems \(selectedItems)")
        setFlowLayout()
        
    }
    
    func setFlowLayout() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        if bookmarkCollectionView.isHidden == false {
            print("flowLayout bookmarkCollectionView")
            flowLayout.minimumLineSpacing = 10
            flowLayout.minimumInteritemSpacing = 10
            let width: CGFloat = UIScreen.main.bounds.width / 3
            let height: CGFloat = width * 0.7
            flowLayout.itemSize = CGSize(width: width * 0.8, height: height)
            self.bookmarkCollectionView.backgroundColor = .white
            self.bookmarkCollectionView.collectionViewLayout = flowLayout
        }
        if detailView.isHidden == false {
            print("flowLayout detailView")
            
            flowLayout.minimumLineSpacing = 10.0
            flowLayout.minimumInteritemSpacing = 1.0
            let width: CGFloat = UIScreen.main.bounds.width / 2 - 10.0
            flowLayout.itemSize = CGSize(width: width * 0.9, height: 150)
            self.bookmarkDetailCollectionView.backgroundColor = .white
            self.bookmarkDetailCollectionView.collectionViewLayout = flowLayout
        }
    }
    
    func deleteCoreData(productName: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        for managedObject in productBookmarkedData {
            print("managedObject \(managedObject)")
            let string = managedObject.value(forKey: "productName") as! String
            print("delete data \(string)")
            if string == productName {
                managedContext.delete(managedObject)
                do {
                    try managedContext.save()
                    print(managedContext)
                    return true
                } catch let error as NSError {
                    print("Could not update. \(error), \(error.userInfo)")
                    return false
                }
            }
        }
        return true
    }
    
    func updateCoreData(object: NSManagedObject, productName: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        do {
            object.setValue(productName, forKey: "productName")
            
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func saveCoreData(productName: String) -> Bool {
        // App Delegate 호출
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        // App Delegate 내부에 있는 viewContext 호출
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // managedContext 내부에 있는 entity 호출
        let entity = NSEntityDescription.entity(forEntityName: "Bookmarks", in: managedContext)!
        
        // entity 객체 생성
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 값 설정
        object.setValue(productName, forKey: "productName")
        do {
            // managedContext 내부의 변경사항 저장
            try managedContext.save()
            print("save data \(productName)")
            
            return true
        } catch let error as NSError {
            // 에러 발생시
            print("Could not save. \(error)")
            return false
        }
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        detailData.removeAll()
        detailView.isHidden = true
        addView.isHidden = true
        initView.isHidden = false
        defaultView.isHidden = true
        setFlowLayout()
        bookmarkCollectionView.isHidden = false
        print(showData)
        bookmarkCollectionView.reloadData()
    }
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        initView.isHidden = true
        addView.isHidden = false
        bookmarkCollectionView.isHidden = false
        detailView.isHidden = true
        // productData 전체 리스트 띄우기
        bookmarkedStringArr = showData
        showData.removeAll()
        showData = productAllData
        for item in bookmarkedStringArr {
            if let index = showData.firstIndex(of: item){
                if !selectedItems.contains([0, index]){
                    selectedItems.append([0, index])
                    
                }
            }
        }
        print("addbutton tapped \(selectedItems)")
        bookmarkCollectionView.reloadData()
        print("add Button tapped bookmarkedStringArr \(bookmarkedStringArr)")
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        // productData에 즐찾 한것만 띄우기
        initView.isHidden = false
        addView.isHidden = true
        tempSave.removeAll()
        showData.removeAll()
        for managedObject in productBookmarkedData {
            let string = managedObject.value(forKey: "productName") as? String ?? ""
            showData.append(string)
        }
        
        bookmarkCollectionView.reloadData()
        print(bookmarkedStringArr)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        initView.isHidden = true
        addView.isHidden = false
        showData.removeAll()
        // 저장하기 누르면
        // tempSave랑 productBookmarkedData 랑 비교해서
        // 만약에 tempSave에 있는게 productBookmarkedData에 없으면 추가
        // 반대로 tempSave에 없는게 productBookmarkedData에 있으면 삭제
        
        
        if productBookmarkedData.count != 0 {
            print("saveButtonTapped tempSave \(tempSave)")
            
            tempSave.forEach{ productName in
                if !bookmarkedStringArr.contains(productName){
                    saveCoreData(productName: productName)
                }
                
            }
            tempDelete.forEach{ productName in
                print("삭제 productName \(productName)")
                deleteCoreData(productName: productName)
            }
        }
        else {
            print("productBookmarkedData == 0")
            tempSave.forEach { productName in
                saveCoreData(productName: productName)
            }
        }
        
        tempSave.removeAll()
        showData.removeAll()
        
        for managedObject in productBookmarkedData {
            let string = managedObject.value(forKey: "productName") as? String ?? ""
            showData.append(string)
        }
        
        
        print("last showData \(showData)")
        bookmarkCollectionView.reloadData()
        
        initView.isHidden = false
        addView.isHidden = true
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        print("BookmarkVC Touched")
        completionHandler?("BookmarkVC Touched2")
    }
    
    
    func fetch() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Bookmarks")
        
        let result = try! context.fetch(fetchRequest)
        return result
    }
    
}

extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("cell Count")
        defaultView.isHidden = true
        
        if bookmarkCollectionView.isHidden == false {
            print("bookmarkCollectionView")
            print("showData.count \(showData.count)")
            
            return showData.count
        }
        if detailView.isHidden == false {
            print("detailView")
            print("detailData.count \(detailData.count)")
            
            if detailData.count == 0 {
                defaultView.isHidden = false
            }
            else {
                defaultView.isHidden = true
            }
            return detailData.count
        }
        return showData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cell create")
        print("detailData count2 \(self.detailData.count)")
        
        if detailView.isHidden == false {
            guard let auctionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyAuctionCell", for: indexPath) as? DailyAuctionCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            auctionCell.generateCell(dailyAuction:detailData[indexPath.item])
            return auctionCell
        }
        else {
            guard let bookmarkCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkCell", for: indexPath) as? BookmarkCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            bookmarkCell.bookmarkImageView.contentMode = .scaleAspectFill
            if initView.isHidden == false {
                
                // initView 보여지고 있는 상태
                // showData == 0 일 수 있음 (즐찾 없는 상태)
                if showData.count != 0 {
                    bookmarkCell.productName.text = self.showData[indexPath.row]
                    bookmarkCell.bookmarkImageView.image = UIImage(named: "BookmarkCheckedImage")
                }
                return bookmarkCell
            }
            if addView.isHidden == false {
                
                print("isSelected \(selectedItems)")
                print("초기화면?")
                
                
                // addView 보여지고 있는 상태
                // showData = allData
                print("StringArr \(bookmarkedStringArr)")
                print("selectedItems \(selectedItems)")
                bookmarkCell.productName.text = self.showData[indexPath.row]
                bookmarkCell.isSelected = selectedItems.contains(indexPath)
                
                if selectedItems.contains(indexPath){
                    print("\(bookmarkCell.productName!) is selected")
                    bookmarkCell.bookmarkImageView.image = UIImage(named: "BookmarkCheckedImage")
                }
                else {
                    print("\(bookmarkCell.productName) is not selected")
                    bookmarkCell.bookmarkImageView.image = UIImage(named: "BookmarkUncheckedImage")
                }
                
                
                return bookmarkCell
            }
            return bookmarkCell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if detailView.isHidden == false {
            // 세부 탭에서 cell 선택 시
            // detailInfoVC로 넘어가도록
            guard let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as? DetailInfoViewController else { return }
            // 화면 전환 애니메이션 설정
            detailVC.modalTransitionStyle = .coverVertical
            // 전환된 화면이 보여지는 방법 설정 (fullScreen)
            let data = self.detailData[indexPath.row]
            detailVC.getDetailData(detailData: data)
            
            detailVC.modalPresentationStyle = .fullScreen
            self.present(detailVC, animated: true, completion: nil)
        }
        // Update the appearance of the selected cell
        if addView.isHidden == false {
            guard let bookmarkCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkCell", for: indexPath) as? BookmarkCollectionViewCell else {return}
            
            bookmarkCell.bookmarkImageView.contentMode = .scaleAspectFill
            if !selectedItems.contains(indexPath) {
                
                selectedItems.append(indexPath)
                tempSave.append(productAllData[indexPath.row])
                if let index = tempDelete.firstIndex(of: productAllData[indexPath.row]) {
                    tempDelete.remove(at: index)
                }
                bookmarkCell.bookmarkImageView.image = UIImage(named: "BookmarkCheckedImage")
                print("선택에 추가해야함")
                
            }
            else if selectedItems.contains(indexPath) {
                print("already selected items")
                
                if let index = selectedItems.firstIndex(of: indexPath) {
                    selectedItems.remove(at: index)
                }
                if let index = tempSave.firstIndex(of: productAllData[indexPath.row]) {
                    tempSave.remove(at: index)
                }
                if let index = bookmarkedStringArr.firstIndex(of: productAllData[indexPath.row]) {
                    tempDelete.append(productAllData[indexPath.row])
                }
                print("선택에서 없애야함")
                bookmarkCell.bookmarkImageView.image = UIImage(named: "BookmarkUncheckedImage")
                
            }
            
            print("selectedItems \(selectedItems)")
            print("tempSave \(tempSave)")
            print("tempDelete \(tempDelete)")
            
            collectionView.reloadItems(at: [indexPath])
            
        }
        if initView.isHidden == false {
            // 즐찾 내용 중 하나 선택 시
            // cell data 변경해야함
            detailData.removeAll()
            var productName = showData[indexPath.row]
            let authKey = "766c476c676b6e793132345770716c57"
            let requestType = "json"
            let serviceName = "GarakGradePrice"
            let path = "http://openapi.seoul.go.kr:8088/\(authKey)/\(requestType)/\(serviceName)/1/100/\(productName)"
            guard let encodedStr = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
            
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
                        let filteredAuction = dailyAuction.filter({ ($0["AVGPRICE"] as? Float) != 0.0 &&  $0["PUMNAME"] as! String == productName})
                        filteredAuction.forEach{
                            auctions.append(DailyAuctionResponse(auctionDictionary: $0))
                        }
                    }
                    self.detailData.append(contentsOf: auctions)
                    
                    self.detailView.isHidden = false
                    self.bookmarkCollectionView.isHidden = true
                    self.addView.isHidden = true
                    self.initView.isHidden = true
                    self.bookmarkDetailCollectionView.dataSource = self
                    self.bookmarkDetailCollectionView.delegate = self
                    self.setFlowLayout()
                    self.bookmarkDetailCollectionView.reloadData()
                    
                    self.bookmarkDetailCollectionView.isHidden = false
                    
                case .failure(let error):
                    print(error.localizedDescription)
                default:
                    fatalError()
                }
                
            }
        }
        
    }
}
