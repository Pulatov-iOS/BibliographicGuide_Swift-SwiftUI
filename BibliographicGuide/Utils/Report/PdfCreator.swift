//
//  PdfCreator.swift
//  BibliographicGuide
//
//  Created by Alexander on 20.04.23.
//

import PDFKit

class PdfCreator : NSObject {
    
    var pag = 0
    var recordsIncludedReport: [Record] = []
    var titleReport = ""
    var creatorReport = ""

lazy var pageWidth : CGFloat  = {
    return 8.5 * 72.0
}()

lazy var pageHeight : CGFloat = {
    return 11 * 72.0
}()

lazy var pageRect : CGRect = {
    CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
}()

lazy var marginPoint : CGPoint = {
    return CGPoint(x: 70, y: 70)
}()
    
lazy var marginSize : CGSize = {
    return CGSize(width: self.marginPoint.x * 2 , height: self.marginPoint.y * 2)
}()


func pdfData(recordsIncludedReport: [Record], titleReport: String, creatorReport: String) -> Data {
    self.recordsIncludedReport = recordsIncludedReport
    self.titleReport = titleReport
    self.creatorReport = creatorReport
    //1
    let pdfMetaData = [
      kCGPDFContextCreator: "PDF Creator",
      kCGPDFContextAuthor: "Pulatov A. P.",
      kCGPDFContextTitle: "Report"
    ]

    //2
    let format = UIGraphicsPDFRendererFormat()
    format.documentInfo = pdfMetaData as [String: Any]

    //3
    let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)

    //5
    let data = renderer.pdfData { (context) in
        
        var journals = ""
        var pointer = ""
        var ii = 1;
        
        for item in recordsIncludedReport{
            journals = journals + "\t" + String(ii) + ". " + item.journalName + ". " + "\n"
            pointer = pointer + "\t" + String(ii) + ". " + item.authors + item.title + " // " + item.journalName + " - " + String(item.year) + ", " + item.journalNumber + ", c. " + item.pageNumbers + ". \n"
            ii += 1
        }
        
        //6
        self.addText( "", context: context)
        self.addText( "Список использованных журналов:" + "\n\n" + journals + "\n\n" + "Алфавитный указатель литературы:" + "\n\n" + pointer, context: context)
        
    }

    return data
}
    
    private func addTitle(title: String, xx: Int, yy: Int){
        let textRect = CGRect(x: xx, y: yy,
                              width: Int(pageRect.width) - 40, height: 40)
        title.draw(in: textRect, withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular)])
    }
    
    private func addImage(xx: Int, yy: Int){
        let textRect = CGRect(x: xx, y: yy,
                              width: 90, height: 90)
        var image = UIImage(named: "BSTU") ?? UIImage()
        image.draw(in: textRect)
    }
    
    
@discardableResult
func addText(_ text : String, context : UIGraphicsPDFRendererContext) -> CGFloat {
    
    // 1
    let textFont = UIFont.systemFont(ofSize: 16.0, weight: .regular)

    // 2
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .justified
    paragraphStyle.lineBreakMode = .byWordWrapping

    // 3
    let textAttributes = [
        NSAttributedString.Key.paragraphStyle: paragraphStyle,
        NSAttributedString.Key.font: textFont
    ]

    //4
    let currentText = CFAttributedStringCreate(nil, text
                                                as CFString,
                                               textAttributes as CFDictionary)
   
    //5
    var framesetter = CTFramesetterCreateWithAttributedString(currentText!)
    framesetter = CTFramesetterCreateWithAttributedString(currentText!)
   
    //6
    var currentRange = CFRangeMake(0, 0)
    var currentPage = 0
    var done = false
    
    repeat {

        //7
        // Начало новой страницы
        context.beginPage()

        if(pag == 1){
            currentPage += 1
        }
        if(currentPage == 0 && pag == 0){
            addTitle(title: "БЕЛОРУСКИЙ ГОСУДАРСТВЕННЫЙ ТЕХНОЛОГИЧЕСКИЙ", xx: 70, yy: 100)
            addTitle(title: "УНИВЕРСИТЕТ", xx: 70, yy: 120)
            
            addTitle(title: self.titleReport, xx: 70, yy: 415)
            
            addTitle(title: "Библиографический указатель", xx: 70, yy: 505)
            
            addTitle(title: "Составитель: " + self.creatorReport, xx: 70, yy: 545)
            
            addTitle(title: "Минск 2023", xx: 260, yy: 710)
        
            addImage(xx: 260, yy: 190)
            
            pag = 1
        }
        
        //8
        // Номер страницы внизу каждой страницы
        
        currentPage += 1
        drawPageNumber(currentPage)

        //9
        // Отобразить текущую страницу и обновить текущий диапазон, чтобы он указывал на начало следующей страницы.
        currentRange = renderPage(currentPage,
                                  withTextRange: currentRange,
                                  andFramesetter: framesetter)

        //10
        // Если подошли к концу текста, выйти из цикла
        if currentRange.location == CFAttributedStringGetLength(currentText) {
            done = true
        }

    } while !done

    return CGFloat(currentRange.location + currentRange.length)
}

func renderPage(_ pageNum: Int, withTextRange currentRange: CFRange, andFramesetter framesetter: CTFramesetter?) -> CFRange {
    var currentRange = currentRange
    // Get the graphics context.
    let currentContext = UIGraphicsGetCurrentContext()

    // Put the text matrix into a known state. This ensures
    // that no old scaling factors are left in place.
    currentContext?.textMatrix = .identity

    // Create a path object to enclose the text. Use 72 point
    // margins all around the text.
    let frameRect = CGRect(x: self.marginPoint.x, y: self.marginPoint.y, width: self.pageWidth - self.marginSize.width, height: self.pageHeight - self.marginSize.height)
        let framePath = CGMutablePath()
        framePath.addRect(frameRect, transform: .identity)

    // Get the frame that will do the rendering.
    // The currentRange variable specifies only the starting point. The framesetter
    // lays out as much text as will fit into the frame.
    let frameRef = CTFramesetterCreateFrame(framesetter!, currentRange, framePath, nil)

    // Core Text draws from the bottom-left corner up, so flip
    // the current transform prior to drawing.
    currentContext?.translateBy(x: 0, y: self.pageHeight)
    currentContext?.scaleBy(x: 1.0, y: -1.0)

    // Draw the frame.
    CTFrameDraw(frameRef, currentContext!)

    // Update the current range based on what was drawn.
    currentRange = CTFrameGetVisibleStringRange(frameRef)
    currentRange.location += currentRange.length
    currentRange.length = CFIndex(0)

    return currentRange
}

    func drawPageNumber(_ pageNum: Int) {

        let theFont = UIFont.systemFont(ofSize: 16)

        let pageString = NSMutableAttributedString(string: "\(pageNum)")
        pageString.addAttribute(NSAttributedString.Key.font, value: theFont, range: NSRange(location: 0, length: pageString.length))

        let pageStringSize =  pageString.size()

        let stringRect = CGRect(x: 570,
                                y: 750,
                                width: pageStringSize.width,
                                height: pageStringSize.height)

        pageString.draw(in: stringRect)

    }
}
