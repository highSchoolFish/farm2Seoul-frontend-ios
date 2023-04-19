//
//  ViewController.swift
//  farm2Seoul-frontend-ios
//
//  Created by 강보현 on 2023/04/18.
//

import UIKit
import Tabman
import Pageboy

class MainTabViewController: TabmanViewController {
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchImageButton: UIImageView!


    private var viewControllers: [UIViewController] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainTabVC viewDidLoad")
        // Do any additional setup after loading the view.
        
        let dailyAuctionVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DailyAuctionVC") as! DailyAuctionViewController
        let infoBoardVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "InfoBoardVC") as! InfoBoardViewController
        let bookmarkVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BookmarkVC") as! BookmarkViewController
        
        viewControllers.append(dailyAuctionVC)
        viewControllers.append(infoBoardVC)
        viewControllers.append(bookmarkVC)
        
        self.dataSource = self
        
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
        return viewControllers[index]
    }
    
    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }
}
