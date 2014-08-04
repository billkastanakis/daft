Execution time: 6 hours.

Video:
[![Alt text for your video](http://i.imgur.com/zEs6NSP.png)](https://www.youtube.com/watch?v=nY7hkCVXRC4)

Features:
- Seamless transitions.
- Compatible with 3.5 and 4 inch devices.
- Asynchronous operations.
- Animated UI.
- No third party frameworks / controls used.

- Clean reusable code using best practices for iOS Development.
- Method and variable names are long and descriptive. 
- There are not comments to controller to avoid pollution. Method names are clean and self explanatory. Code in controllers separated with #pragma marks.
- Dot notation syntax is only used to avoid nested brackets. e.g. I use [NSNumber numberWithInt:property.price] instead of [NSNumber numberWithInt:[property price]]
- BKGlobalConstants class to keep all the constants that may be used by multiple classes.
- UIColor+Extension to easily access custom colors used in the app theme. 
- All classes using the appropriate private variables and methods. Public methods used exclusively if external access needed.
- In the project there is an Assets folder with the .sketch files used in this project. A vector logo is created to be used in icons and intro screens.

To Do:
- Some proper unit testing
- Some proper Error handling (e.g. where there is no network connection).
- Separate some code into classes. E.g. I usually separate the datasources to separate classes in order to feed different controllers with the same data. In a case that in iPad a UICollectionView is used, and in iPhone a UITableView is used can use the same datasource.