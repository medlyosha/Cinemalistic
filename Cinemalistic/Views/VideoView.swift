//
//  VideoPlayer.swift
//  Cinemalistic
//
//  Created by Lesha Mednikov on 29.09.2023.
//

import SwiftUI
import WebKit
struct VideoView: UIViewRepresentable {

    let videoID: String
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: configuration )
        guard let youtubeURL = URL(string:"https://www.youtube.com/embed/\(videoID)") else { return WKWebView()  }
        webView.scrollView.isScrollEnabled = false
        webView.load(URLRequest(url: youtubeURL))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string:"https://www.youtube.com/embed/\(videoID)") else { return }
        uiView.scrollView.isScrollEnabled = false
        uiView.load(URLRequest(url: youtubeURL))
    }
}
