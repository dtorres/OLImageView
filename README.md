#OLImageView (and OLImage)

You love GIFs right? so do I!. 
Well, as you may know Apple's implementation of UIImage doesn't support animated GIFs (Booooooo!) and that's what this classes are for.

This classes are drop-in replacements for UIImage and UIImageView respectively.

##Why this classes

When I created this classes there were a bunch of classes that added GIF support but had these issues:

- They divided evenly the total delay between frames (Yeah, usually GIFs have even delays but when they don't...) 
- Loaded synchronously. Which is fine except the process per frame is heavy, and only when finished the image was visible.

But even having resolved those issues the experience wasn't how we are used to them.

After a little of digging I found out the browsers changed the delays on certain condition. Mostly bad encoded GIFs. This implementation adopts those conditions to provide a consistent experience with the browsers.

##How to use

Replace UIImageView for OLImageView and add the header.

**Example**

    //Before (in your viewController in this example)
	- (void)loadView 
	{
		[super loadView];
		self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
		[self.view addSubview:self.imageView];
	}



	//After
	
	#import "OLImageView.h"
	- (void)loadView 
	{
		[super loadView];
		self.imageView = [[OLImageView alloc] initWithFrame:CGRectMake(0,0,200,200)];
		[self.view addSubview:self.imageView];
	}
	
No, we are not done yet.
Now, when you create your image instances to put in the view you show do it with the data.

**Example**

    - (void)loadReceivedImageData:(NSData *)data;
	{
		UIImage *image = [OLImage imageWithData:data];
		self.imageView.image = image;
	}
	
##Categories

In this repo is included a category to integrate OLImage with AFNetworking's [UIImageView's](https://github.com/AFNetworking/AFNetworking/blob/master/AFNetworking/UIImageView%2BAFNetworking.h) category which provides caching and remote URL setters.
To make use of this just import the category where you are using OLImageView with AFNetworking category.

You are more than welcome to send Pull Requests with categories or subclasses that integrate OLImage with other Libraries.

##Help us make this better

Found a bug? a typo? Can you make the decoding faster?. Feel free to fork it and send a pull request (or file an issue).
