HBPullToRefreshTableViewController

A simple iPhone TableViewController for adding pull-to-refresh functionality. This fork allows for custom PullToRefresh UIView.

![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-1.png)
![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-2.png)
![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-3.png)
![](http://s3.amazonaws.com/leah.baconfile.com/blog/refresh-small-4.png)

Inspired by:

1. [Tweetie 2](http://www.atebits.com/tweetie-iphone/)

2. [Oliver Drobnik's blog post](http://www.drobnik.com/touch/2009/12/how-to-make-a-pull-to-reload-tableview-just-like-tweetie-2/)

3. [EGOTableViewPullRefresh](http://github.com/enormego/EGOTableViewPullRefresh)

4. [Leah Culver's PullRefreshTableViewController](https://raw.github.com/leah/PullToRefresh)



How to install:

1. Copy all the files under HBPullToRefreshTableViewController to your project.

2. Link against the QuartzCore framework (used for rotating the arrow image).

3. Create a TableViewController that is a subclass of HBPullToRefreshTableViewController.

4. Create a custom UIView<HBPullToRefreshView> and add it to the new TableViewController created in step 3. (OR use the default HBDfaultPullToRefreshView UIView)

For more details please see DemoTableViewController and DemoPullToRefreshView.

Enjoy!
