//
//  PHPickerView.swift
//  MyCamera
//
//  Created by 習田武志 on 2022/07/10.
//

import SwiftUI
import PhotosUI

struct PHPickerView: UIViewControllerRepresentable {
    // フォトライブラリー画面（sheet）の開閉状態を管理
    @Binding var isShowSheet: Bool
    // フォトライブラリーから読み込む写真
    @Binding var captureImage: UIImage?
    
    // Coordinatorでコントローラのdelegateを管理
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        // PHPickerView型の変数を用意
        var parent: PHPickerView
        
        // イニシャライザ
        init(parent: PHPickerView) {
            self.parent = parent
        }
        
        // フォトライブラリで写真を選択・キャンセルしたときに実行される
        // delegateメソッド、必ず必要
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // 写真は１つだけ選べる設定なので、最初の１件を指定
            if let result = results.first {
                // UIImage型の写真のみ非同期で取得
                result.itemProvider.loadObject(ofClass: UIImage.self) {
                    (image, error) in
                    // 写真が取得できたら
                    if let unwrapImage = image as? UIImage {
                        // 選択された写真を追加する
                        self.parent.captureImage = unwrapImage
                    } else {
                        print("使用できる写真がないです")
                    }
                }
            } else {
                print("選択された写真はないです")
            }
            // sheetを閉じる
            parent.isShowSheet = false
        } // picker終了
    }
    
    // Coordinatorを生成、Swiftによって自動的に呼び出し
    func makeCoordinator() -> Coordinator {
        // Coordinatorクラスのインスタンスを生成
        Coordinator(parent: self)
    }
    
    // Viewを生成するときに実行
    func makeUIViewController(context:UIViewControllerRepresentableContext<PHPickerView>) -> PHPickerViewController {
        // PHPickerViewControllerのカスタマイズ
        var configuration = PHPickerConfiguration()
        // 静止画を選択
        configuration.filter = .images
        // フォトライブラリーで選択できる枚数を１枚にする
        configuration.selectionLimit = 1
        // PHPickerViewControllerのインスタンスを生成
        let picker = PHPickerViewController(configuration: configuration)
        // delegate設定
        picker.delegate = context.coordinator
        // PHPickerViewControllerを返す
        return picker
    }

    // Viewが更新されたときに実行
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: UIViewControllerRepresentableContext<PHPickerView>) {
        // 処置なし
    }
}
