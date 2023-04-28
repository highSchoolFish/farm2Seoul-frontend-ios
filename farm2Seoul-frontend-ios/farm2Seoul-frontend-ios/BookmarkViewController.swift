//
//  BookmarkViewController.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/18.
//

import UIKit
import CoreData

class BookmarkViewController: UIViewController {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var initView: UIView!
    
    @IBOutlet var bookmarkCollectionView: UICollectionView!
    
    let interval = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    
    var productBookmarkedData: [NSManagedObject] {
        return self.fetch()
    }
    var selectedItems = [IndexPath]()
    var bookmarkedStringArr: [String] = []
    var showData: [String] = []
    var tempSave: [String] = []
    var productAllData:[String] = ["(냉)갈치", "(냉)고등어", "(냉)고등어수입", "(선)갈치", "(선)고등어", "(선)명태수입", "가리비", "가무락(모시조개)", "가시오이", "가오리수입", "가자미", "가지", "갈치수입", "감대봉시", "감말랭이", "감약시", "감귤", "감귤극조생", "감귤금귤", "감귤비가림", "감귤온주", "감귤하우스", "감숭어", "감자", "감자대지마", "감자두백", "감자수미", "감자수미(저장)", "감자수미(햇)", "감자수입", "갑오징어", "갯장어", "건고구마순수입", "건꼴뚜기", "건대멸치", "건미역대각", "건세멸치", "건소멸치", "건오징어근해", "건자멸치", "건중멸치", "건토란대수입", "건파래", "겉홍합", "겨자잎", "고구마", "고구마풍원미", "고수", "골드파인애플수입", "곰취나물", "곶감국산", "굴", "그린빈스", "그린키위국산", "근대", "김개량", "김재래", "깐바지락", "깐쪽파", "깻잎", "꽃게수입", "꽃게수", "꽃게암", "꽃느타리버섯", "꽈리고추", "낙지수입", "냉동가자미수입", "냉동꽁치", "냉동낙지", "냉동낙지수입", "냉동오징어(연안)", "냉동오징어(원양)", "냉동조기수입", "냉동주꾸미수입", "냉이", "냉이수입", "냉태원양", "노각오이", "노랑파프리카", "녹광고추", "논우렁", "느타리버섯", "늙은호박", "다발무", "다시마", "단감부유", "단감상서", "단감서촌", "단감송본", "단호박수입", "단호박(일반)", "달래(일반)", "당귀잎", "당근", "당근수입", "대구", "대구냉장수입", "대구수입", "대파수입", "대파(일반)", "대합", "도루묵", "돗나물", "동죽", "둥근애호박", "딸기", "딸기금실", "딸기설향", "딸기육보", "딸기장희", "딸기죽향", "땅두릅(재배산)", "땅콩수입", "레드치커리", "레몬수입", "로메인(일반)", "로케트루꼴라", "롱그린고추", "마늘쫑", "만가닥버섯", "만감레드향", "만감천혜향", "만감한라봉", "만감황금향", "맛", "망고국산", "매생이(일반)", "머위대", "멍게", "메론머스크", "메론파파야", "명태피포", "모과", "몽키바나나수입", "무", "무순", "무화과국산", "문어", "물오징어", "미나리", "미더덕", "민어", "바나나수입", "바실", "바지락", "바지락수입", "반청갓", "방풍나물", "배신고", "배원황", "배추", "배추얼갈이", "백다다기오이", "백색메론", "백조기", "뱅어포", "병어", "복분자(일반)", "복수박", "복숭아가납암", "복숭아경봉", "복숭아그레이트", "복숭아레드골드", "복숭아미백", "복숭아백도기타", "복숭아백봉", "복숭아사자", "복숭아선광", "복숭아선프레", "복숭아신비", "복숭아신선", "복숭아아부백도", "복숭아암킹", "복숭아애천중도", "복숭아엘버트", "복숭아올인", "복숭아월미", "복숭아월봉", "복숭아유명백도", "복숭아창방", "복숭아천도기타", "복숭아천중도백도", "복숭아천홍", "복숭아호기도", "복숭아환타지아", "복숭아황도기타", "봄동배추", "봉지미역", "봉지바지락", "부세수입", "부추(일반)", "북어대태", "북어채", "브로콜리", "브로콜리국산", "브로콜리수입", "블루베리국산", "블루베리수입", "비름", "비타민", "비트", "비트국산", "빨간양배추국산", "빨간양배추수입", "빨강파프리카", "사과감홍", "사과로얄부사", "사과미시마", "사과미야비", "사과미얀마", "사과부사", "사과시나노레드", "사과시나노스위트", "사과아오리", "사과양광", "사과요까", "사과홍로", "사과홍옥", "사과홍장군", "사과히로사끼", "사과대추", "산딸기국산", "살구개량", "삼치", "상추", "상추적포기", "상추포기찹", "새꼬막", "새송이버섯", "새우수입", "새조개", "생강구강", "생강원강", "생강재강", "생대추", "생취나물", "생표고", "생표고수입", "　석류수입", "셀러리", "소라", "수박", "수박(일반)", "수삼5년근", "시금치", "시금치섬초", "시금치포항초", "실파", "쌈배추", "쑥", "쑥(일반)", "쑥갓", "씀바귀", "아귀냉장수입", "아귀(일반)", "아로니아국산", "아보카도수입", "아스파라가스국산", "아욱", "알배기배추", "애호박", "앵두국산", "양배추", "양배추수입", "양상추", "양상추수입", "양상추(일반)", "양송이", "양파", "양파수입", "양파조생", "양파(햇)", "연근(일반)", "열무", "염장다시마", "영양부추", "오디국산", "오렌지네블수입", "오렌지발렌샤수입", "오렌지파프리카", "오만둥이", "오이맛고추", "완두콩", "유자", "육쪽마늘", "임연수어", "임연수어수입", "잉어", "자두대석", "자두정상", "자두추희", "자두후무사", "자몽수입", "자주양파", "저장양파", "적겨자잎", "적근대", "적로메인", "적상추", "적어수입", "전어", "절임배추", "주꾸미", "주꾸미수입", "죽순국산", "중하", "쥬키니호박", "쪽파(일반)", "쫑상추", "찰옥수수", "참나물", "참두릅(자연산)", "참숭어", "참외(일반)", "참조기", "청갓", "청경채", "청매실", "청상추", "청양고추", "청어", "청초", "청피망", "체리국산", "취나물", "취청오이", "치커리(일반)", "칼리플라워", "케일", "코다리명태", "콜라비(일반)", "키위기타수입", "토마토", "토마토대저", "토마토대추방울", "토마토방울", "토마토완숙", "통로메인파세리", "파인애플수입", "팽이버섯", "포도거봉", "포도네오머스켓", "포도델라웨어", "포도마스컷(MBA)", "포도샤인머스켓", "포도수입", "포도청포도", "포도캠벨얼리", "풋고추(일반)", "피뿔고동(소라)", "피조개", "해삼", "햇마늘난지", "햇마늘남도", "햇마늘대서", "햇마늘한지", "호박고구마", "호박밤고구마", "홍감자", "홍게", "홍고추", "홍어수입", "홍자두", "홍피망", "홍합살", "활넙치(양식)", "활넙치(자연)", "활노래미(자연)", "활농어수입", "활농어(자연)", "활돔(양식)", "활돔(자연)", "활미꾸라지(양식)", "활민어(자연)", "활방어(자연)", "활우럭(양식)", "활우럭(자연)", "활전복(양식)", "활전어(자연)", "활점성어수입", "활꽃게수", "활꽃게암", "활낙지수입", "활도다리(자연)", "활메기(양식)", "활민물장어(양식)", "황색메론"]
    
    var bookmarkArr: [NSLayoutManager]?
    
    // persistentContainer로 접근하기 위한 NSManagedObjectContext를 생성
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(productBookmarkedData)
        bookmarkCollectionView.allowsMultipleSelection = true
        
        self.bookmarkCollectionView.register(UINib(nibName: "BookmarkCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "bookmarkCell")
        self.bookmarkCollectionView.dataSource = self
        self.bookmarkCollectionView.delegate = self
        setFlowLayout()
        
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
        
        // delete all data
        for managedObject in productBookmarkedData {
            deleteCoreData(object: managedObject)
        }
        
        // init
        for managedObject in productBookmarkedData {
            let string = managedObject.value(forKey: "productName") as? String ?? ""
            self.bookmarkedStringArr.append(string)
            showData.append(string)
        }
        print(bookmarkedStringArr)
        print(selectedItems.count)
        print(selectedItems)
        
    }
    
    func setFlowLayout() {
        let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 3
        flowLayout.minimumInteritemSpacing = 3
        let width: CGFloat = UIScreen.main.bounds.width / 3 - 32
        flowLayout.itemSize = CGSize(width: width * 0.9, height: width * 0.7)
        self.bookmarkCollectionView.backgroundColor = .white
        self.bookmarkCollectionView.collectionViewLayout = flowLayout
        
    }
    
    func deleteCoreData(object: NSManagedObject) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        for managedObject in productBookmarkedData {
            let string = managedObject.value(forKey: "productName") as! String
            print("delete data \(string)")
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
        // 객체를 넘기고 바로 삭제
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
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        initView.isHidden = true
        addView.isHidden = false
        // productData 전체 리스트 띄우기
        
        showData.removeAll()
        
        showData = productAllData
        bookmarkCollectionView.reloadData()
        print(bookmarkedStringArr)
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
            tempSave.forEach { productName in
                print("productBookmarkedData != 0")
                
                for managedObject in productBookmarkedData {
                    let string = managedObject.value(forKey: "productName") as? String ?? ""
                    if string == productName {
                        // 이미 존재 --> delete
                        print("이미 존재 함")
                        deleteCoreData(object: managedObject)
                    }
                    
                }
                print("새로 추가")
                saveCoreData(productName: productName)
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
        self.view.endEditing(true)
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
        return showData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
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
                return bookmarkCell
            }
        }
        if addView.isHidden == false {
            // addView 보여지고 있는 상태
            // showData = allData
            bookmarkCell.productName.text = self.showData[indexPath.row]
            bookmarkCell.isSelected = selectedItems.contains(indexPath)
            if bookmarkCell.isSelected {
                bookmarkCell.bookmarkImageView.image = UIImage(named: "BookmarkCheckedImage")

            }
            if !bookmarkCell.isSelected {
                bookmarkCell.bookmarkImageView.image = UIImage(named: "BookmarkUnCheckedImage")

            }
//            for managedObject in productBookmarkedData {
//                let string = managedObject.value(forKey: "productName") as? String ?? ""
//                if showData[indexPath.row].contains(string) {
//                    print("\(bookmarkCell.productName.text) selected")
//                    bookmarkCell.bookmarkImageView.image = UIImage(named: "BookmarkCheckedImage")
//                }
//                if !showData[indexPath.row].contains(string) {
//                    print("\(bookmarkCell.productName.text) unselected")
// v                }
//            }
            
//            if bookmarkCell.isSelected {
//                print("\(bookmarkCell.productName.text) selected")
//                bookmarkCell.bookmarkImageView.image = UIImage(named: "BookmarkCheckedImage")
//            }
//            if !bookmarkCell.isSelected {
//                print("\(bookmarkCell.productName.text) unselected")
//                bookmarkCell.bookmarkImageView.image = UIImage(named: "BookmarkUncheckedImage")
//            }
            print("create cell \(productBookmarkedData.count)")
        }
        return bookmarkCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("cell selected")
        print("cell selected \(indexPath)")

        // Update the appearance of the selected cell
        guard let bookmarkCell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookmarkCell", for: indexPath) as? BookmarkCollectionViewCell else {return}
        if addView.isHidden == false {
            bookmarkCell.bookmarkImageView.contentMode = .scaleAspectFill
            if !selectedItems.contains(indexPath) {
                print("new item")
                selectedItems.append(indexPath)
                tempSave.append(productAllData[indexPath.row])
                bookmarkCell.bookmarkImageView.image = UIImage(named: "BookmarkCheckedImage")
            }
            else if selectedItems.contains(indexPath) {
                print("already selected items")
                
                bookmarkCell.bookmarkImageView.image = UIImage(named: "BookmarkUnCheckedImage")
                if let index = selectedItems.firstIndex(of: indexPath) {
                    selectedItems.remove(at: index)
                }
                if let index = tempSave.firstIndex(of: productAllData[indexPath.row]) {
                    tempSave.remove(at: index)
                }
            }
            print("select tempSave \(tempSave)")
            collectionView.reloadItems(at: [indexPath])

        }
        if initView.isHidden == false {
            
        }
    }
    
}
