 
IMPORTANT: This project is no longer being maintained, please have a look at [FLAnimatedImage](https://github.com/Flipboard/FLAnimatedImage)

# OLImageView (and OLImage)
Everybody loves a good GIF. Unfortunately, Apple's implementation of UIImage doesn't support animated GIFs. OLImage and OLImageView are drop-in replacements for UIImage and UIImageView with really good support for animated GIFs.

## Why did we do this?
There are many other classes to do this already, but they just don't work the way they should. Most existing classes:

- Divide the delay between frames evenly, all the time (even if the file specifies different per-frame delays)
- Load frames synchronously, which freezes up the main thread (especially when loading large files) and only show anything when all the frames are loaded

We tried to fix some of these issues, but we found that the experience still didn't feel quite right. After a little of digging, we found out that browsers change the frame delays on certain conditions. This implementation adopts these conditions to provide an experience that is consistent with the WebKit rendering of an animated GIF.

## How to use
Add the header and replace UIImageView with OLImageView.

**Example**

    // Before (in your View Controller in this example)
    
	- (void)loadView 
	{
		[super loadView];
		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
		[self.view addSubview:self.imageView];
	}


	// After
	
	#import "OLImageView.h"
	
	- (void)loadView 
	{
		[super loadView];
		self.imageView = [[OLImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
		[self.view addSubview:self.imageView];
	}
	
Now, when you create your image instances to put in the view, you should do it with the data.

**Example**

    - (void)loadReceivedImageData:(NSData *)data;
	{
		UIImage *image = [OLImage imageWithData:data];
		self.imageView.image = image;
	}
	
## Integration with other libs
### AFNetworking
This repo includes a category to integrate OLImage with AFNetworking v1.x [UIImageView category](https://github.com/AFNetworking/AFNetworking/blob/1.x/AFNetworking/UIImageView+AFNetworking.h), which provides caching and remote URL setters.
To use this, just import the category where you will be using OLImageView with the AFNetworking category.

Users of AFNetworking 2.x can use any of the two provided image reponse serializers. `OLImageResponseSerializer` is a drop-in replacement for the standard AFNetworking serializer, which simply creates OLImage instances for every data:

    imageView.imageResponseSerializer = [[OLImageResponseSerializer alloc] init];

Those who want to keep default `AFImageResponseSerializer` behavior or need to chain many serializers, there's a strict one, only accepting image/gif: `OLImageStrictResponseSerializer`. Serializer chaining might look like this:

    imageView.imageResponseSerializer =
        [AFCompoundResponseSerializer compoundSerializerWithResponseSerializers:
            @[[[OLImageStrictResponseSerializer alloc] init], imageView.imageResponseSerializer]];

You are more than welcome to send pull requests with categories or subclasses that integrate OLImage with other libraries.

## Help us make this better
Found a bug? A typo? Can you make the decoding faster? Feel free to fork this and send us a pull request (or file an issue).
