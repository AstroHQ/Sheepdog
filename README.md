# Sheepdog

Sheepdog is a set of Objective-C categories that add higher order methods like map, filter, reduce and their ilk. Sheepdog is heavily influenced by Clojure and in particular the functions available in Clojure.Core. 

Sheepdog is just two files and highly tested.

## Examples

More examples are available in the docs. This is just a taste:

```
NSArray *array = @[@(1), @(-1)];
[array map:^id(id obj) {
    return @([obj integerValue] + 1);
}];
--> [2, 0]

NSArray *array = @[@(1), @(-1), @(2), @(4)];
[array every:^BOOL(id obj) {
    return [obj integerValue] < 0;
}];
--> NO

NSArray *array = @[@(1), @(2), @(3), @(4)];
[array partition:2];
--> [[1, 2], [3,4]]

NSArray *array = @[@"bob", @"mat", @"sing", @"song"];
[array partitionBy:^id(id obj) {
   return @([obj length]);
}];
--> {3: ["bob", "mat"], 4: ["sing", "song"]}
```

## Why?

I made Sheepdog after becoming frusterated with other open source options. Some of the problems I have with existing options include:

* Requiring Objective-C runtime hacks
* Overly complex because of chaining
* Having lots of dependencies

## Advantages
* Just two files, super easy to add to your project!
* No dependencies
* Works on iOS & Mac
* Tested
* Simple

## Disadvantages
* Only supports NSArray and NSSet currently
* No chaining
* Not as feature rich as something like Underscore.m

## License

MIT Licensed. Have fun.

## Contact

Matt Ronge
[@mronge](http://www.twitter.com/mronge)