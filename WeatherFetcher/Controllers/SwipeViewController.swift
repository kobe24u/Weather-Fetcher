//
//  SwipeViewController.swift
//  WeatherFetcher
//
//  Created by Vinnie Liu on 6/2/21.
//

import UIKit

class SwipeViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

//    fileprivate var presenter: SwipePresenter!
    fileprivate var viewModel: SwipeViewModel
    
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    fileprivate var orderedViewControllers: [UIViewController] = [UIViewController]()
    fileprivate var pageViewController: UIPageViewController!
    
    init(viewModel: SwipeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: "SwipeViewController", bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageViewSetup()
        setupViewModel()
    }
    
    func setupViewModel(){
        viewModel.addWeatherPagesClosure = { [weak self] viewControllers in
            self?.addWeatherPage(viewControllers: viewControllers)
            self?.reloadWeatherPage()
        }
        
        viewModel.permissionDeniedClosure = { [weak self] in
            self?.presentActionAlert(title: "Whoops", message: "Please grant GPS permission for this app") {
                let viewModel = WeatherViewModel(coord: (Constants.melbLat, Constants.melbLon))
                let weatherController = WeatherViewController(viewModel: viewModel)
                self?.addWeatherPage(viewControllers: [weatherController])
            }
        }
    }
    
    // Page view Setting
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let firstViewController = pageViewController.viewControllers?.first,
           let index = orderedViewControllers.firstIndex(of: firstViewController) {
            pageControl.currentPage = index
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pageControl.numberOfPages = orderedViewControllers.count
        return orderedViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = pageViewController.viewControllers?.first,
              let firstViewControllerIndex = orderedViewControllers.firstIndex(of: firstViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return nil
        }
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        return orderedViewControllers[nextIndex]
    }
    
    fileprivate func pageViewSetup() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        self.addChildViewController(containerView: weatherView, childVC: pageViewController)
    }
    
    func addWeatherPage(viewControllers: [UIViewController]) {
        orderedViewControllers.removeAll()
        for viewController in viewControllers {
            orderedViewControllers.append(viewController)
        }
    }
    
    func reloadWeatherPage() {
        let indexPage = Constants.indexPage
        if orderedViewControllers.indices.contains(indexPage) {
            pageControl.currentPage = indexPage
            pageViewController.setViewControllers([orderedViewControllers[indexPage]],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
}
