# 🐨 KoalaInjection

Evil but simple code injection, don't use!

## Example

```swift
let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0))
view.backgroundColor = UIColor.red

view.koala.layoutSubviews { ✅ // inject code after original implementation
    $0.backgroundColor = UIColor.blue
}
```

### Advanced

#### • extract arguments

```swift
let viewController = UIViewController()

viewController.koala.setTitle { ✅
    print($1.arguments()[0] as NSString)
}
```

#### • change arguments

```swift
let viewController = UIViewController()

viewController.koala.before.viewWillDisappear { ✅
    $1.arguments()[0] = true
}
```

#### • return values

```swift
let viewController = UIViewController()

viewController.koala.prefersStatusBarHidden { ✅
    return Bool.random()
}
```

#### • change returned values

```swift
let viewController = UIViewController()
viewController.title = "Hello"

viewController.koala.title { ✅
    return ($2 as NSString?)?.appending(" world")
}
```

## Author

Oliver Letterer, oliver.letterer@gmail.com

## License

KoalaInjection is available under the MIT license. See the LICENSE file for more info.
