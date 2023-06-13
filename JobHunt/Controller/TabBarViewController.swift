//
//  TabBarViewController.swift
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    //MARK:- Variables
    var homeNavController = UINavigationController()
    var favouritesNavController = UINavigationController()
    var profileNavController = UINavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabbar()
    }


    //MARK:- setup Tabbar
    func setupTabbar() {

        delegate = self
        
        let selectedColor   = UIColor.black
        let unselectedColor = UIColor.gray
        
        let tabBarAppearance = UITabBarAppearance()
        let tabBarItemAppearance = UITabBarItemAppearance()

        tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: unselectedColor]
        tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: selectedColor]

        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBar.standardAppearance = tabBarAppearance

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeVC = storyboard.instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
        homeVC.tabBarItem.title = "Home"
        homeVC.tabBarItem.image = UIImage(named: "ic_home_grey")!.withRenderingMode(.alwaysOriginal)
        homeVC.tabBarItem.selectedImage = UIImage(named: "ic_home")!.withRenderingMode(.alwaysOriginal)
        homeNavController = UINavigationController(rootViewController: homeVC)
        homeNavController.isNavigationBarHidden = true

        let savedJobVC = storyboard.instantiateViewController(withIdentifier: "profileVC") as! SavedJobViewController
        savedJobVC.tabBarItem.title = "Saved jobs"
        savedJobVC.tabBarItem.image = UIImage(named: "ic_fav_grey")!.withRenderingMode(.alwaysOriginal)
        savedJobVC.tabBarItem.selectedImage = UIImage(named: "ic_fav")!.withRenderingMode(.alwaysOriginal)
        favouritesNavController = UINavigationController(rootViewController: savedJobVC)
        favouritesNavController.isNavigationBarHidden = true
        
        let profileVC = storyboard.instantiateViewController(withIdentifier: "savedVC") as! ProfileViewController
        profileVC.tabBarItem.title = "Profile"
        profileVC.tabBarItem.image = UIImage(named: "ic_profile_grey")!.withRenderingMode(.alwaysOriginal)
        profileVC.tabBarItem.selectedImage = UIImage(named: "ic_profile")!.withRenderingMode(.alwaysOriginal)
        profileNavController = UINavigationController(rootViewController: profileVC)
        profileNavController.isNavigationBarHidden = true
        

        let tabBarList = [homeNavController, favouritesNavController, profileNavController]
        self.viewControllers = tabBarList
        navigationController?.navigationBar.isHidden = true


    }


    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

        return true
    }

}
