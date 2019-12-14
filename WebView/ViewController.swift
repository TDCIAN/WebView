//
//  ViewController.swift
//  WebView
//
//  Created by APPLE on 2019/12/14.
//  Copyright © 2019 JeongminKim. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var txtUrl: UITextField!
    @IBOutlet weak var myWebView: WKWebView!
    @IBOutlet weak var myActivityIndicator: UIActivityIndicatorView!
    
    // 특정 웹 페이지를 로드하는 함수
    func loadWebPage(_ url: String) {
        let myUrl = URL(string: url) // 상수 myUrl은 url 값을 받아 URL형으로 선언합니다
        let myRequest = URLRequest(url: myUrl!) // 상수 myRequest는 상수 myUrl을 받아 URL Request형으로 선언합니다
        myWebView.load(myRequest) // UIWebView형의 myWebView 클래스의 load 메서드를 호출합니다
        
        // 웹 뷰가 로딩중인지 살펴보기 위한 addObserver 함수
        myWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebPage("https://www.naver.com")
        /*
         웹 페이지가 로드 되기 위해서는 Info.plist 파일을 수정해야 합니다.(Info.plist는 Information property List의 약자이며, 키-값 쌍(key/value pair)의 정보가 저장되어 있습니다.
         이 파일 안에는 언어, 실행 파일 이름 및 앱 식별자 등등의 항목들과 관련된 리소스 설정이 들어 있습니다.
         1. Info.plist 파일에서 Information Property List의 오른쪽에 있는 [+]를 눌러 항목을 추가합니다.
         2. 드롭 다운 목록에서 키보드 방향 키로 이동해 [App Transport Security Settings]를 선택합니다.
         3. 이후 [App Transport Security Settings] 왼쪽의 화살표가 아래로 향하도록 한 다음 다시 한 번 [+]를 누릅니다.
         4. 이번엔 선택 항목 두 개가 나타납니다. [Allow Arbitrary Loads]를 마우스로 선택한 후 리턴을 눌러 완료합니다.
         5. [Allow Arbitrary Loads]의 [Value] 값을 오른쪽에 있는 화살표를 눌러 [NO]를 [YES]로 변경합니다.
         */
    }
    
    // observeValue를 재설정
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" { // 로딩중인지 확인
            if myWebView.isLoading { // myWebView가 로딩 중일 때와 그렇지 않을 때를 구분하는 코드 추가
                myActivityIndicator.startAnimating() // 로딩중이라면 인디케이터 실행
                myActivityIndicator.isHidden = false // 로딩중이라면 인디케이터를 보이게 함
            } else {
                myActivityIndicator.stopAnimating() // 로딩이 끝났다면 인디케이터 중지
                myActivityIndicator.isHidden = true // 로딩이 끝났다면 인디케이터 숨김
            }
        }
    }
    
    // 홈페이지 주소를 문자열(String)로 받고, 이를 처리한 후 다시 문자열로 가져오는 checkUrl 함수
    func checkUrl(_ url: String) -> String {
        var strUrl = url // 입력받은 url 스트링을 임시 변수 strUrl에 넣습니다
        let flag = strUrl.hasPrefix("https://") // "https://"를 가지고 있는지 확인한 값을 flag에 넣습니다
        if !flag {
            strUrl = "https://" + strUrl
        }
        return strUrl // "https://"를 가지고 있지 않다면, 즉 '!flag'일 때 변수 strUrl에 "https://"를 추가하고 이를 리턴합니다.
    }

    // [Go] 버튼을 클릭할 때 텍스트 필드에 적힌 주소로 웹 뷰가 로딩되게 해주는 btnGoUrl 함수
    @IBAction func btnGotoUrl(_ sender: UIButton) {
        let myUrl = checkUrl(txtUrl.text!) // checkUrl 함수에 텍스트 필드에 적힌 주소를 호출하여 변수 myUrl로 받습니다
        txtUrl.text = ""
        loadWebPage(myUrl) // 이를 loadWebPage함수를 이용하여 웹 뷰에 로딩합니다.
    }
    @IBAction func btnGoSite1(_ sender: UIButton) {
        loadWebPage("https://www.google.co.kr")
    }
    @IBAction func btnGoSite2(_ sender: UIButton) {
        loadWebPage("https://www.daum.net")
    }
    @IBAction func btnLoadHtmlString(_ sender: UIButton) {
        // HTML문을 변수에 저장합니다
        // HTML 코드를 대입할 때는 큰따옴표 안에 넣어야 합니다. 그런데 이 때 줄을 바꿔 입력하면 에러가 발생합니다. 따라서 HTML 코드를 줄 바꿈 없이 사용해야 합니다.
        let htmlString = "<h1> HTML String </h1><p> String 변수를 이용한 웹피이지 </p><p><a href=\"https://www.youtube.com\">YouTube로 이동</p>"
        // loadHTMLString 함수를 이용하여 변수에 저장된 HTML 문을 웹 뷰에 나타냅니다.
        myWebView.loadHTMLString(htmlString, baseURL: nil)
    }
    @IBAction func btnLoadHtmlFile(_ sender: UIButton) {
        // htmlView.html 파일에 대한 패스 변수를 생성합니다
        let filePath = Bundle.main.path(forResource: "htmlView", ofType: "html")
        // 패스 변수를 이용하여 URL 변수를 생성합니다
        let myUrl = URL(fileURLWithPath: filePath!)
        // URL 변수를 이용하여 Request 변수를 생성합니다
        let myRequest = URLRequest(url: myUrl)
        // Request 변수를 이용하여 HTML 파일을 로딩합니다
        myWebView.load(myRequest)
    }
    // 정지
    @IBAction func btnStop(_ sender: UIBarButtonItem) {
        myWebView.stopLoading()
    }
    // 재로딩
    @IBAction func btnReload(_ sender: UIBarButtonItem) {
        myWebView.reload()
    }
    // 이전 페이지
    @IBAction func btnGoBack(_ sender: UIBarButtonItem) {
        myWebView.goBack()
    }
    // 다음 페이지
    @IBAction func btnGoForward(_ sender: UIBarButtonItem) {
        myWebView.goForward()
    }
    
    
    
    
}

