//
//  ImagePickerView.swift
//  MyCamera
//
//  Created by 習田武志 on 2022/06/24.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    // UIImagePickerController（写真撮影）が表示されているかを管理
    @Binding var isShowSheet: Bool
    
    // 撮影した写真を格納する変数
    @Binding var captureImage: UIImage?

    // Coordinatorでコントローラのdelegateを管理
    class Coordinator: NSObject,
                        UINavigationControllerDelegate,
                       UIImagePickerControllerDelegate {
        // ImagePickerView型の定数を用意
        let parent: ImagePickerView
        
        // イニシャライザ
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        // 撮影が終わったときに呼ばれるdelegateメソッド、必ず必要
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info:
            [UIImagePickerController.InfoKey : Any]) {
                
            // 撮影した写真をcaptureImageに保存
            if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.captureImage = originalImage
            }
            // sheetを閉じる
            parent.isShowSheet = false
        }
        
        // キャンセルボタンが選択されたときに呼ばれる
        
        // delegateメソッド、必ず必要
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            // sheetを閉じる
            parent.isShowSheet = false
        }
    } // Coordinatorここまで
    
    // coordinatorを生成し、SwiftUIによって自動的に呼び出し
    func makeCoordinator() -> Coordinator {
        // Coordinatorクラスのインスタンスを生成
        Coordinator(self)
    }
    
    // Viewを生成するときに実行
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        // UIImagePickerControllerのインスタンスを生成
        let myImagePickerController = UIImagePickerController()
        
        // sourceTypeにCameraを設定
        myImagePickerController.sourceType = .camera
        
        // delegate設定
        myImagePickerController.delegate = context.coordinator
        
        // UIImagePickerControllerを返す
        return myImagePickerController
    }
    
    // Viewが更新されたときに実行
    func updateUIViewController(
        _ uiViewController: UIImagePickerController,
        context: UIViewControllerRepresentableContext<ImagePickerView>) {
        // 処理なし
    }
    
} // ImagePickerViewここまで
