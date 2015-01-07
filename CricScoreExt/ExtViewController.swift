//
//  ExtViewController.swift
//  CricScoreWidget
//
//  Created by Ravindra Kishan on 07/01/15.
//  Copyright (c) 2015 Ravindra Kishan. All rights reserved.
//

import UIKit
import NotificationCenter

class scorewidgetCustomCell: UITableViewCell
{
    @IBOutlet var scoreLabel: UILabel!
}

class ExtViewController: UITableViewController,NSXMLParserDelegate, NCWidgetProviding
{

    var parser: NSXMLParser = NSXMLParser()
    var scoreArray:[ScoreWidget] = []
    var scoreInfo: String = String()
    var items: String = String()
    
    let CellIdentifier: String = "widgetCell"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let url:NSURL = NSURL(string:"http://static.cricinfo.com/rss/livescores.xml")!
        parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
    }
    
    //NSXMLParser Delegate methods
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!)
    {
        items = elementName
        if elementName == "item"
        {
            scoreInfo = String()
        }
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!)
    {
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if (!data.isEmpty)
        {
            if items == "title"
            {
                scoreInfo += data
            }
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!)
    {
        if elementName == "item"
        {
            let scoreInf:ScoreWidget = ScoreWidget()
            scoreInf.scoreTitle = scoreInfo
            scoreArray.append(scoreInf)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Tableview Delegate Methods
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return scoreArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 50.0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: scorewidgetCustomCell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as scorewidgetCustomCell
        var score: ScoreWidget = scoreArray[indexPath.row]
        cell.scoreLabel?.text = score.scoreTitle
        return cell
    }
    
    
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.NewData)
    }


}
