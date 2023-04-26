//
//  InfoBoardViewController.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/18.
//

import UIKit

class InfoBoardViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var corporationButton: UIButton!
    @IBOutlet weak var noticeButton: UIView!
    @IBOutlet weak var reportButton: UIView!
    @IBOutlet weak var auctionTimeButton: UIView!
    @IBOutlet weak var iNuriButton: UIButton!
    @IBOutlet weak var marketImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var marketName = ["서울청과", "농협(공)", "중앙청과", "동화청과", "한국청과", "대아청과", "강동수산", "수협(공)", "서울건해", "서부청과", "강서청과"]
    
    var marketImages = ["GarakImage", "GangSeoImage", "YangGokImage"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()
        
        collectionView.isUserInteractionEnabled = true
        pageControl.isUserInteractionEnabled = true
        collectionView.delaysContentTouches = false
        marketImageView.isUserInteractionEnabled = true
        makeButton()
        setViewGesture()
        makeImageViewPaging()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 80, height: 60)
        collectionView.collectionViewLayout = flowLayout
        //         한 손가락 스와이프 제스쳐 등록(좌, 우)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        marketImageView.addGestureRecognizer(swipeLeft)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        marketImageView.addGestureRecognizer(swipeRight)
        
        // Set delaysContentTouches to false on scroll view
        scrollView.delaysContentTouches = false
        
        registerXib()
    }
    
    @objc func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        // 만일 제스쳐가 있다면
        print("gesture")
        if let swipeGesture = gesture as? UISwipeGestureRecognizer{
            
            // 발생한 이벤트가 각 방향의 스와이프 이벤트라면
            // pageControl이 가르키는 현재 페이지에 해당하는 이미지를 imageView에 할당
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.left :
                print("좌")
                pageControl.currentPage += 1
                marketImageView.image = UIImage(named: marketImages[pageControl.currentPage])
            case UISwipeGestureRecognizer.Direction.right :
                print("우")
                pageControl.currentPage -= 1
                marketImageView.image = UIImage(named: marketImages[pageControl.currentPage])
            default:
                break
            }
            
        }
        
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: "MarketCollectionViewCell", bundle: nil)
        collectionView.register(nibName, forCellWithReuseIdentifier: "marketCell")
    }
    
    func setViewGesture() {
        let noticeViewTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(noticeButtonTapped(_:)))
        noticeButton.addGestureRecognizer(noticeViewTapGesture)
        
        let reportViewTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(reportButtonTapped(_:)))
        reportButton.addGestureRecognizer(reportViewTapGesture)
        
        let auctionTimeViewTapGeseture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(auctionTimeButtonTapped(_:)))
        auctionTimeButton.addGestureRecognizer(auctionTimeViewTapGeseture)
    }
    
    func makeImageViewPaging() {
        marketImageView.image = UIImage(named: marketImages[0])
        marketImageView.contentMode = .scaleAspectFill
        
        pageControl.numberOfPages = marketImages.count
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = UIColor(named: "MainColor")
        pageControl.currentPage = 0
    }
    
    @IBAction func changePage(_ sender: UIPageControl) {
        marketImageView.image = UIImage(named: marketImages[pageControl.currentPage])
    }
    
    @objc func noticeButtonTapped(_ sender: UITapGestureRecognizer) {
        print("noticeButtonTapped")
        //        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommunityVC") else {
        //            print("guard fail")
        //            return
        //        }
        //        vc.modalPresentationStyle = .fullScreen
        //        self.present(vc, animated: true)
    }
    
    @objc func reportButtonTapped(_ sender: UITapGestureRecognizer) {
        print("tapped")
        //        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CommunityVC") else {
        //            print("guard fail")
        //            return
        //        }
        //        vc.modalPresentationStyle = .fullScreen
        //        self.present(vc, animated: true)
    }
    
    @objc func auctionTimeButtonTapped(_ sender: UITapGestureRecognizer) {
        print("noticeButtonTapped")
        guard let auctionTimeVC = self.storyboard?.instantiateViewController(withIdentifier: "AuctionTimeVC") else {
            print("guard fail")
            return
        }
        auctionTimeVC.modalPresentationStyle = .fullScreen
        self.present(auctionTimeVC, animated: true)
    }
    
    @objc func marketButtonTapped(_ sender: UITapGestureRecognizer) {
        if let indexString = sender.accessibilityValue,
           let index = Int(indexString) {
            print(index)
            
            guard let webKitVC =  storyboard?.instantiateViewController(identifier: "WebKitVC") as? WebKitViewController else
            { return }
            switch index {
            case 0 :
                webKitVC.urlString = "http://www.egreenland.co.kr"
            case 1 :
                webKitVC.urlString = "http://newgp.nonghyup.com/index.jsp"
            case 2 :
                webKitVC.urlString = "http://www.ejoongang.co.kr"
            case 3 :
                webKitVC.urlString = "http://www.donghwafp.com/web/Main.aspx"
            case 4 :
                webKitVC.urlString = "https://www.hkck.co.kr/index.aspx"
            case 5 :
                webKitVC.urlString = "https://www.dagreen.co.kr/main/main.asp"
            case 6 :
                webKitVC.urlString = "http://www.kdsusan.co.kr/main2/"
            case 7 :
                webKitVC.urlString = "https://www.suhyup.co.kr/suhyup/index.do"
            case 8 :
                webKitVC.urlString = "http://www.seoulgunhae.com"
            case 9 :
                webKitVC.urlString = "http://www.sbbot.com/main/index.do"
            case 10 :
                webKitVC.urlString = "http://www.ksfresh.co.kr"
            default:
                break
            }
            //
//            guard let webKitVC = self.storyboard?.instantiateViewController(withIdentifier: "WebKitVC") else {
//                print("guard fail")
//                return
//            }
            print(webKitVC.urlString)
            webKitVC.modalPresentationStyle = .fullScreen
            self.present(webKitVC, animated: true)
            // Use the index value here
        }
    }
    
    @IBAction func iNuriButtonTapped(_ sender: UIButton){
        print("iNuriButtonTapped")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func makeButton() {
        noticeButton.layer.cornerRadius = 40
        noticeButton.clipsToBounds = true
        noticeButton.backgroundColor = UIColor(named: "InfoButtonColor")
        noticeButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        noticeButton.layer.shadowOpacity = 0.5
        noticeButton.layer.shadowRadius = 2
        noticeButton.layer.masksToBounds = false
        
        auctionTimeButton.layer.cornerRadius = 40
        auctionTimeButton.clipsToBounds = true
        auctionTimeButton.backgroundColor = UIColor(named: "InfoButtonColor")
        auctionTimeButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        auctionTimeButton.layer.shadowOpacity = 0.5
        auctionTimeButton.layer.shadowRadius = 2
        auctionTimeButton.layer.masksToBounds = false
        
        reportButton.layer.cornerRadius = 40
        reportButton.clipsToBounds = true
        reportButton.backgroundColor = UIColor(named: "InfoButtonColor")
        reportButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        reportButton.layer.shadowOpacity = 0.5
        reportButton.layer.shadowRadius = 2
        reportButton.layer.masksToBounds = false
        
        corporationButton.layer.cornerRadius = 40
        corporationButton.clipsToBounds = true
        corporationButton.backgroundColor = UIColor(named: "InfoButtonColor")
        corporationButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        corporationButton.layer.shadowOpacity = 0.5
        corporationButton.layer.shadowRadius = 2
        corporationButton.layer.masksToBounds = false
        
        iNuriButton.layer.cornerRadius = 40
        iNuriButton.clipsToBounds = true
        iNuriButton.backgroundColor = UIColor(named: "InfoButtonColor")
        iNuriButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        iNuriButton.layer.shadowOpacity = 0.5
        iNuriButton.layer.shadowRadius = 2
        iNuriButton.layer.masksToBounds = false
        
    }
}

extension InfoBoardViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 11
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "marketCell", for: indexPath) as?
                MarketCollectionViewCell else {
            return UICollectionViewCell()
        }
        let market = marketName[indexPath.row]
        cell.marketButton.setTitle(market, for: .normal)
        cell.marketButton.backgroundColor = UIColor(named: "MarketButtonColor")
        
        let marketButtonTapGesture = UITapGestureRecognizer(target: self, action: #selector(marketButtonTapped(_:)))
        marketButtonTapGesture.numberOfTapsRequired = 1
        marketButtonTapGesture.delegate = self
        marketButtonTapGesture.accessibilityValue = "\(indexPath.row)"
        cell.marketButton.addGestureRecognizer(marketButtonTapGesture)
        return cell
    }
    
}
