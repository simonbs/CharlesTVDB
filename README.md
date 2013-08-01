# CharlesTVDB

CharlesTVDB is a block based framework for OS X which provides interface for [TheTVDB.com](http://thetvdb.com) which is extremely easy to use.

### Installation
First and foremost you have to clone the repository. You probably already know how to do this.

	git clone https://github.com/simonbs/CharlesTVDB.git
	
Next, you have to install the dependencies using CocoaPods. If you don't already have CocoaPods installed, you will have to [install it first](http://cocoapods.org).

	pod install

This will install [AFKissXMLRequestOperation](https://github.com/AFNetworking/AFKissXMLRequestOperation) and its dependencies: [AFNetworking](https://github.com/AFNetworking/AFNetworking) and [KissXML](https://github.com/robbiehanson/KissXML)

Now, build the framework and grab it from the products directory and drag it into your own project. You're ready to use CharlesTVDB!

### Usage

First, you will have to grab an API key from [TheTVDB.com](http://thetvdb.com). If you have an account and you are logged in, you can [register your application here](http://thetvdb.com/?tab=apiregister) to get an API key.

Now that you have your API key, you can configure `CharlesClient` with it. `CharlesClient` is a singleton which holds some necessary information.
You can do this wherever you want but it is only necessary to do it once. I recommend doing it in `-applicationDidFinishLaunching:`.

	CharlesClient *charles = [CharlesClient sharedClient];
	charles.apiKey = @"YourAPIKey";
	
#### Setting the Language

Optionally, you can set the language on the client. This can be changed at any time but any data already loaded will have to be reloaded to be updated with texts in the new language.

CharlesTVDB is entirely block based which makes it insanly easy to use. If you want a list of the languages that TheTVDB provdes, you can load them like this:

	[CharlesLanguage loadAllLanguages:^(NSArray *languages) {
        // Languages are loaded, when setting the langauge on the CharesClient you are interested in the abbreviation
        for (CharlesLanguage *language in languages) {
            NSLog(@"%@", language.abbreviation);
        }
    } failure:^(NSError *error) {
        // Handle the error
    }];
    
The above just loads a list of all the available languages and logs them to the console. If you want to set language on CharlesClient, you should use the `abbreviation` that an instance of CharlesLanguage provides.

#### Searching for TV series

You can search for a TV series by its name. Below we search for "The Mentalist" and print the name of all the results we found.

	[CharlesTVSeries searchTVSeriesByName:@"The Mentalist" completion:^(NSArray *results) {
        for (CharlesTVSeries *tvSeries in results) {
            NSLog(@"%@", tvSeries.name);
        }
    } failure:^(NSError *error) {
        // Handle the error
    }];

#### Loading a TV series from an ID

You might have saved an ID for a TV series and want to look it up on TheTVDB. This ID can either be a TheTVDBs own ID (that's the `identifier` property on an instance of CharlesTVSeries) or it can be an IMDb ID or a Zap2it ID. The last two are also accessible on instances of  CharlesTVSeries.

Depending on the ID you have, you want to use one of the three static methods on the CharlesTVSeries.

	+ (void)loadTVSeriesWithId:(NSUInteger)seriesId completion:(void (^)(CharlesTVSeries *tvSeries))completion failure:(void (^)(NSError *error))failure;
	+ (void)loadTVSeriesWithImdbId:(NSString *)imdbId completion:(void (^)(CharlesTVSeries *tvSeries))completion failure:(void (^)(NSError *error))failure;
	+ (void)loadTVSeriesWithZap2itId:(NSString *)zap2itId completion:(void (^)(CharlesTVSeries *tvSeries))completion failure:(void (^)(NSError *error))failure;

For example, if you have the IMDb ID *tt0773262* (that's the ID for [Dexter](http://www.imdb.com/title/tt0773262) you can retrive the TV series like this:

	[CharlesTVSeries loadTVSeriesWithImdbId:@"tt0773262" completion:^(CharlesTVSeries *tvSeries) {
        if (tvSeries)
        {
            NSLog(@"%@", tvSeries.name);
        }
    } failure:^(NSError *error) {
        // Handle the error
    }];	
    
Notice that we check if the `tvSeries` from the completion block is nil. This is because, that it is not considered an error if the TV series does not exist. Instead you won't get any TV series. Please handle this in your application.

#### Loading the details of a TV series

Due to the way the API provided by TheTVDB works, you won't always get all the information. When searching for a TV series seasons, episodes, some artwork and more is not loaded but if you load a TV series with the ID provided by TheTVDB, you will get all information, including all seasons and episodes. However, if you load the TV series with an IMDb or Zap2it ID, you will not get all the information.

Details can be loaded by calling `-loadDetails:` on a CharlesTVSeries object. If the details are already loaded, the completion block will be called immediately so that no unnecessary requests are made.

The details are stored in an CharlesTVSeriesDetails object on CharlesTVSeries so it is easy to distinguish between information which is always loaded and information which might be loaded.

You can check if the details are already loaded by the `isDetailsLoaded` property on instances of CharlesTVSeries.

#### Artwork

You will find a banner on instances of CharlesTVSeries and in the details of the TV series you can find fanart and a poster. The artwork is stored in instanes of CharlesArtwork and to save bandwidth and potentially unnecessary requests, the images are not loaded right away.
You can load an image by calling `-loadImage:` on the artwork. If the image is already loaded, it won't be loaded again. Instead, the completion block will be called immediately.

The `isLoaded` property tells if the image is already loaded or not.

### Credits

The framework is developed by [@simonbs](http://twitter.com/simonbs), [simonbs.dk](http://simonbs.dk) Feel free to fork the repository and send pull requests if you have made something awesome.

### License

Copyright (C) 2013 Simon B. Støvring

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.