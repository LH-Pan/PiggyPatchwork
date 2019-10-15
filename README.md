# PiggyPatchwork

PiggyPatchwork 是一款拼貼照片的 app，裡面提供許多不同的樣板讓你能夠重新排版成新的照片。  
除了拼貼照片外，還能夠將不同的照片組合成影片，並且可以自由地調整影片順序，讓照片不再只是靜置的圖片。  

[<img src="https://github.com/LH-Pan/PiggyPatchwork/blob/master/ScreenShot/app_store_icon.jpg" width="180">](https://apps.apple.com/tw/app/id1481181391)

# Screen Shot

<img src="https://github.com/LH-Pan/PiggyPatchwork/blob/master/ScreenShot/Screen%20Shot%201.png" width="240" >  <img src="https://github.com/LH-Pan/PiggyPatchwork/blob/master/ScreenShot/Screen%20Shot%202.png" width="240" >  <img src="https://github.com/LH-Pan/PiggyPatchwork/blob/master/ScreenShot/Screen%20Shot%203.png" width="240" >  
   
<img src="https://github.com/LH-Pan/PiggyPatchwork/blob/master/ScreenShot/Screen%20Shot%204.png" width="240" >  <img src="https://github.com/LH-Pan/PiggyPatchwork/blob/master/ScreenShot/Screen%20Shot%205.png" width="240" >  <img src="https://github.com/LH-Pan/PiggyPatchwork/blob/master/ScreenShot/Screen%20Shot%206.png" width="240" >  

# Feature 
- 圖片拼貼
  - 選擇拼貼邊框作為你想要的排版方式，點選拼貼板上的邊框即可連結相簿選擇想要置入的照片
  - 可自由選取搭配背景顏色
  - 選擇顏文字換臉，於樣板中置入可清楚辨識的人臉，接著選擇喜歡的顏文字即可更換表情
  - 拼貼完成後可以預覽結果
  - 藝術塗鴉中可以選擇顏色、線條粗細並自由發揮藝術創作
  - 可將成果儲存於相簿中或分享至個人社群平台
 
<img src="https://github.com/LH-Pan/PiggyPatchwork/blob/master/ScreenShot/collage_present.gif" width="240" >   <img src="https://github.com/LH-Pan/PiggyPatchwork/blob/master/ScreenShot/canvas_present.gif" width="240" >

- 相片製影
  - 點選添加按鈕選擇欲製作成影片的照片，最多可選擇十張
  - 點選刪除鍵即可刪除該照片
  - 長按照片右邊圖示待浮動後即可上下滑動至想要的位置更換順序
  - 可以預覽製作完成的影片
  - 製作完成後可以儲存至相簿中或分享至個人社群平台

<img src="https://github.com/LH-Pan/PiggyPatchwork/blob/master/ScreenShot/tableView_present.gif" width="240" >  <img src="https://github.com/LH-Pan/PiggyPatchwork/blob/master/ScreenShot/photo_movie_preview.gif" width="240">
 
# Technique
- 採用 MVC 架構

- 運用 `Delegate Design Pattern` 在不同 `UIViewController` 之間進行傳值

- 自製 `UIViewControllerAnimatedTransitioning` 來設計 `LuanchScreen` 的轉場動畫

- 自製一個模組化的 `UIView` 畫布
```Swift
class Canvas: UIView {
    
    var lines = [Line]()
    
    var strokeColor = UIColor.red
    
    var strokeWidth: Float = 1
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        lines.forEach { (line) in
            
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
            
            for (endPoint, startPoint) in line.points.enumerated() {
                if endPoint == 0 {
                    context.move(to: startPoint)
                } else {
                    context.addLine(to: startPoint)
                }
            }
            context.strokePath()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        lines.append(Line.init(color: strokeColor,
                               strokeWidth: strokeWidth,
                               points: []))
    }
    
    // track the finger as we move across screen
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard
            let point = touches.first?.location(in: self),
            var lastLine = lines.popLast()
        else { return }

        lastLine.points.append(point)

        lines.append(lastLine)
        
        setNeedsDisplay()
    }
    
    func undo() {
        
        _ = lines.popLast()
        
        setNeedsDisplay()
    }
    
    func clear() {
        
        lines.removeAll()
        
        setNeedsDisplay()
    }
    
    func setStrokeColor(color: UIColor) {
        
        strokeColor = color
    }
    
    func setStrokeWidth(width: Float) {
        
        strokeWidth = width
    }
}

```

- 使用 `CoreML-Vision` 及 `AVFoundation` 進行人臉偵測
```Swift
class FaceDetection {
    
    weak var delegate: FaceDetectionDelegate?
    
    func faceDetection(detect image: UIImage?) {
        
        let detectRequest = VNDetectFaceRectanglesRequest(completionHandler: self.handleFaces)
        
        guard let image = image?.cgImage else { return }
        
        let detectRequestHandler = VNImageRequestHandler(cgImage: image,
                                                         options: [ : ])
        
        do {
            
            try detectRequestHandler.perform([detectRequest])
            
        } catch {
            
            PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.exclamation_mark),
                                         message: "人臉偵測錯誤 (つд⊂)")
        }
    }
    
    func handleFaces(request: VNRequest, error: Error?) {
        
        guard
            let faceDetectResults = request.results as? [VNFaceObservation]
        else {
            fatalError("Unexpected result type from VNDetectFaceRetanglesRequest.")
        }
        
        if faceDetectResults.count == 0 {
            
            PiggyJonAlert.showCustomIcon(icon: UIImage.asset(.exclamation_mark),
                                         message: "這張照片偵測不到人臉 இдஇ")
            return
        }
        
        delegate?.faceDetecter(self, didGet: faceDetectResults)
    }
}
```

# Library
* JonAlert
* ColorSlider
* OpalImagePicker
* Lottie
* Firebase Crashlytics

# Requirement
* iOS 12.0+

# Version
* 1.2.0 - 2019/10/06
  * 修正顏文字換臉完再更換背景顏色回來照片會不見的問題
  * 修正顏文字換臉有時候讀取不到照片的問題
  * 修正在首頁點選功能後畫面會變黑的問題
  * 修正拼貼功能只有一個圖片可以縮放的問題
  * 在拼貼邊框中增加 + 號讓置入照片的目的更明確
  * 現在製影功能儲存時有進度條顯示製作進度
  
* 1.1.2 - 2019/10/01
  * 修正製作影片時某些照片方向會不對的問題
  * 更換小豬的圖片
  * 現在照片可以滑動及縮放了
  * 增加開啟 App 時的動畫

* 1.0.2 - 2019/09/26
  * First release

# Contacts
Henry Pan  
E-mail: salt918077@gmail.com
