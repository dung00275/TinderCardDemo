//
//  TinderCardDemoUITests.swift
//  TinderCardDemoUITests
//
//  Created by Dung Vu on 10/30/20.
//

import XCTest
import RxSwift

class TinderCardDemoUITests: XCTestCase {
    private lazy var disposeBag = DisposeBag()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNoNetwork() {
        let expectation = XCTestExpectation(description: "No Network test")
        let app = XCUIApplication()
        app.launch()

        let settingsApp = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
        settingsApp.launch()
        let query = settingsApp.tables.cells["Airplane Mode"]
        if query.exists {
            query.tap()
            app.activate()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                XCTAssert(app.alerts.count > 0, "Must be show alert network error.")
                expectation.fulfill()
            }
        } else {
            // simulator
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 30.0)
    }
    
    func testLoadDetailCard() {
        let expectation = XCTestExpectation(description: "Load user")
        let app = XCUIApplication()
        app.launch()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssert(app.otherElements["DetailCard_0"].exists, "Must be exist view detail")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 30.0)
    }
    
    func testRemoveDetail() {
        let expectation = XCTestExpectation(description: "Test Clear Card Detail")
        let app = XCUIApplication()
        app.launchArguments = ["requester-load-only-two"]
        app.launch()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let label = "DetailCard_0"
            let q1 = app.otherElements[label]
            if q1.exists {
                q1.swipeLeft(velocity: .default)
            }
            
            XCTAssert(app.otherElements[label].exists == false, "Must be remove")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 30.0)
    }
    
    func testRemoveDetailBehind() {
        let expectation = XCTestExpectation(description: "Test Remove Card Behind")
        let app = XCUIApplication()
        app.launchArguments = ["requester-load-local-file"]
        app.launch()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let label = "DetailCard_1"
            let q1 = app.otherElements[label]
            if q1.exists {
                q1.swipeLeft(velocity: .default)
            }
            
            XCTAssert(app.otherElements[label].exists, "Must be not remove")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 30.0)
    }
    
    private func removeCard(_ app: XCUIApplication, idx: Int) -> Observable<String> {
        return Observable.create { (s) -> Disposable in
            let t = Double(idx) * 3
            DispatchQueue.main.asyncAfter(deadline: .now() + t) {
                let label = "DetailCard_\(idx)"
                let q1 = app.otherElements[label]
                if q1.exists {
                    q1.swipeLeft(velocity: .default)
                    s.onNext(label)
                    s.onCompleted()
                }else {
                    s.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func testRemoveAllCard() {
        let expectation = XCTestExpectation(description: "Test Remve Card Behind")
        let app = XCUIApplication()
        app.launchArguments = ["requester-load-local-file"]
        app.launch()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let list = (0..<2).map { self.removeCard(app, idx: $0) }
            let e = Observable.zip(list)
            e.bind(onNext: { labels in
                labels.forEach {
                    XCTAssert(app.otherElements[$0].exists == false, "Must be remove")
                }
                expectation.fulfill()
            }).disposed(by: self.disposeBag)
        }
        wait(for: [expectation], timeout: 60.0)
    }
    
    func testLoadWrongPath() {
        // UI tests must launch the application that they test.
        let expectation = XCTestExpectation(description: "Load request user api")
        let app = XCUIApplication()
        app.launchArguments = ["requester-testing-wrongPath"]
        app.launch()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssert(app.alerts.count > 0, "Must be show alert error.")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 30.0)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
