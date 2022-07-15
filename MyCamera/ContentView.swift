//
//  ContentView.swift
//  MyCamera
//
//  Created by 習田武志 on 2022/06/24.
//

import SwiftUI

struct ContentView: View {
    // 撮影した写真を保持する状態変数
    @State var captureImage: UIImage? = nil
    // 撮影画像（sheet）の開閉状態を管理
    @State var isShowSheet = false
    // シェア画像の（sheet）の開閉状態を管理
    @State var isShowActivity = false
    // フォトライブラリかカメラかを保持する状態変数
    @State var isPhotolibrary = false
    // 選択画面（ActionSheet）のsheet開閉状態を管理
    @State var isShowAction = false
    
    var body: some View {
        // 縦方向にレイアウト
        VStack {
            // スペースを追加
            Spacer()
            // 撮影した写真があるとき
            if let unwrapCaptureImage = captureImage {
                // 撮影写真を表示
                Image(uiImage: unwrapCaptureImage)
                    // リサイズ
                    .resizable()
                    // アスペクト比（縦横比）を維持して画面内に
                    .aspectRatio(contentMode: .fit)
            }
            // スペースを追加
            Spacer()
            // 「カメラを起動する」ボタン
            Button(action: {
                // ボタンをタップしたときのアクション
                // ActionSheetを表示する
                isShowAction = true
            }) {
                // テキスト表示
                Text("カメラを起動する")
                    // 横幅いっぱい
                    .frame(maxWidth: .infinity)
                    // 高さ50ポイントを指定
                    .frame(height: 50)
                    // 文字列をセンタリング指定
                    .multilineTextAlignment(.center)
                    // 背景を青色に指定
                    .background(Color.blue)
                    // 文字色を白色に指定
                    .foregroundColor(Color.white)
            } // 「カメラを起動する」ボタンここまで
            // 上下左右に余白を追加
            .padding()
            // sheetを表示
            // isPresentedで指定した状態変数がtrueのとき実行
            .sheet(isPresented: $isShowSheet) {
                // フォトライブラリが選択された
                if isPhotolibrary {
                    // PHPickerViewController（フォト）を表示
                    PHPickerView(
                        isShowSheet: $isShowSheet,
                        captureImage: $captureImage)
                } else {
                    // UIImagePickerController（写真撮影）を表示
                    ImagePickerView(
                        isShowSheet: $isShowSheet,
                        captureImage: $captureImage)
                }
            } // 「カメラを起動する」ボタンのsheetここまで
            // 状態変数：$isShowActionに変化があったら実行
            .actionSheet(isPresented: $isShowAction) {
                // ActionSheetを表示
                ActionSheet(title: Text("確認"),
                            message: Text("選択してください"),
                            buttons: [
                        .default(Text("カメラ"), action: {
                            // カメラを選択
                            isPhotolibrary = false
                            // カメラが利用可能かチェック
                            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                                print("カメラは利用できます")
                                // カメラが使えるなら、isShowSheetをtrue
                                isShowSheet = true
                            } else {
                                print("カメラは利用できません")
                            }
                        }),
                        .default(Text("フォトライブラリ"), action: {
                            // フォトライブラリを選択
                            isPhotolibrary = true
                            // isShowSheetをtrue
                            isShowSheet = true
                        }),
                        // キャンセル
                        .cancel(),
                ]) // ActionSheet終了
            } // .actionSheet終了
            // 「SNSに投稿する」ボタン
            Button(action: {
                // ボタンをタップしたときのアクション
                // 撮影した写真があるときだけ
                // UIActivityViewController（シェア機能）を表示
                if let _ = captureImage {
                    isShowActivity = true
                }
            }) {
                Text("SNSに投稿する")
                    // 横幅いっぱい
                    .frame(maxWidth: .infinity)
                    // 高さ50ポイントを指定
                    .frame(height: 50)
                    // 文字列をセンタリング指定
                    .multilineTextAlignment(.center)
                    // 背景を青色に指定
                    .background(Color.blue)
                    // 文字色を白色に指定
                    .foregroundColor(Color.white)
            } // 「SNSに投稿する」ボタン終了
            // 上下左右に余白を追加
            .padding()
            // sheetを表示
            // .isPresentedで指定した状態変数がtrueのとき実行
            .sheet(isPresented: $isShowActivity) {
                // UIActivityViewController（シェア機能）を表示
                ActivityView(shareItems: [captureImage!])
            }
        } // VStackここまで
    } // bodyここまで
} // ContentViewここまで

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
