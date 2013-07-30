import bb.cascades 1.0
import com.kdab.components 1.0
import uk.co.piggz 1.0

Page {
    id: itemView
    property string title: ""
    property string body: ""
    property string link: ""
    property string author: ""
    property string pubdate: ""
    property bool unread: false
    property bool starred: false
    property string guid: ""
    property string guidhash: ""
    property int feedid: 0

    paneProperties: NavigationPaneProperties {
        backButton: ActionItem {
            onTriggered: {
                navigationPane.pop()
            }
        }
    }

    actions: [
        ActionItem {
            id: actionOpen
            title: "Open"
            onTriggered: {
                // will auto-invoke after re-arming
                console.log("open", link);
                invokeLink.query.uri = link;
            }
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///ic_world.png"
        },
        ActionItem {
            id: actionMobiizer
            title: "Instapaper"
            onTriggered: {
                // will auto-invoke after re-arming
                invokeLink.query.uri = "http://mobilizer.instapaper.com/m?u=" + link;
            }
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///ic_mobile.png"
        },
        ActionItem {
            id: actionShare
            title: "Share"
            onTriggered: {
                // will auto-invoke after re-arming
                console.log("share", link);
                invokeQuery.mimeType = "text/plain"
                invokeQuery.data = itemView.title + "\n" + link;
                invokeQuery.updateQuery();
            }
            ActionBar.placement: ActionBarPlacement.OnBar
            imageSource: "asset:///ic_share.png"
        }
    ]

    attachedObjects:
        [
        Invocation {
            id: invokeLink
            property bool auto_trigger: false
            query {
                uri: "http://www.google.com"

                onUriChanged: {
                    invokeLink.query.updateQuery();
                    console.log(uri);
                }
            }

            onArmed: {
                // don't auto-trigger on initial setup
                if (auto_trigger)
                    trigger("bb.action.OPEN");
                auto_trigger = true;    // allow re-arming to auto-trigger
            }
        },
        Invocation {
            id: invokeShare
            query: InvokeQuery {
                id:invokeQuery
                mimeType: "text/plain"
            }
            onArmed: {
                if (invokeQuery.data != "") {
                    trigger("bb.action.SHARE");
                }
            }
        }
    ]

    ScrollView {
        Container {

            leftPadding: 30
            rightPadding:30
            topPadding: 15
            bottomPadding: 15

            Container {
                layout: StackLayout {
                    orientation:  LayoutOrientation.LeftToRight
                }

                Container {
                    layout: DockLayout {        }

                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0
                    }

                    Label {
                        id: lblTitle
                        multiline: true
                        text: title
                        horizontalAlignment: HorizontalAlignment.Left
                        verticalAlignment: VerticalAlignment.Top

                        maxWidth: 600

                        textStyle {
                            base: SystemDefaults.TextStyles.TitleText
                            color: Color.Black
                        }
                    }

                    //Use this view until updating the star status works
                    ImageView {
                        horizontalAlignment: HorizontalAlignment.Right
                        verticalAlignment: VerticalAlignment.Top
                        preferredWidth: 96
                        preferredHeight: 96
                        imageSource: starred ? "star-filled.png" : "star-unfilled.png"
                    }

                    /*
                    ImageToggleButton {
                        id: btnStar
                        horizontalAlignment: HorizontalAlignment.Right
                        verticalAlignment: VerticalAlignment.Top
                        preferredWidth: 96
                        preferredHeight: 96
                        checked: starred
                        imageSourceDefault: "star-unfilled.png"
                        imageSourceChecked: "star-filled.png"

                        onCheckedChanged: {
                            Qt.NewsInterface.setItemStarred(feedid, guidhash, checked);
                        }
                    }
                    */
                }

            }

            /*
            Label {
                id: lblTitle
                multiline: true
                text: title

                textStyle {
                    base: SystemDefaults.TextStyles.TitleText
                    color: Color.Black
                }
            }*/

            Container {

                layout: StackLayout {
                    orientation:  LayoutOrientation.LeftToRight
                }

                Container {
                    layout: DockLayout {
                    }

                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0
                    }

                    Label {
                        id: lblAuthor
                        text: author

                        horizontalAlignment: HorizontalAlignment.Left
                        verticalAlignment: VerticalAlignment.Top

                        textStyle {
                            base: SystemDefaults.TextStyles.TitleText
                            color: Color.Black
                            fontSize: FontSize.Small
                        }
                    }
                    Label {
                        id: lblDate
                        text: pubdate

                        horizontalAlignment: HorizontalAlignment.Right
                        verticalAlignment: VerticalAlignment.Top

                        textStyle {
                            base: SystemDefaults.TextStyles.TitleText
                            color: Color.Black
                            fontSize: FontSize.Small
                        }
                    }
                }
            }

            Label {
                id: lblBody
                multiline: true

                text: "<html>" + strip_tags(body, "<a><b><p><strong><em><i>") + "</html>"

                textStyle {
                    base: SystemDefaults.TextStyles.BodyText
                    textAlign: TextAlign.Left
                }

                function strip_tags (input, allowed) {
                    allowed = (((allowed || "") + "").toLowerCase().match(/<[a-z][a-z0-9]*>/g) || []).join(''); // making sure the allowed arg is a string containing only tags in lowercase (<a><b><c>)
                    var tags = /<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,
                            commentsAndPhpTags = /<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;
                    return input.replace(commentsAndPhpTags, '').replace(tags, function ($0, $1) {
                        return allowed.indexOf('<' + $1.toLowerCase() + '>') > -1 ? $0 : '';
                    });
                }


            }

        }
    }
}
