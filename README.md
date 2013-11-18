# CharlesTVDB

CharlesTVDB is a collection of classes for OS X and iOS which provides a block based interface for [TheTVDB.com](http://thetvdb.com) which is extremely easy to use.

## ARC Required

CharlesTVDB and some of its dependencies requires ARC to be enabled. If you are not already using ARC, now is a good time.

## Installation

If  you are using CocoaPods (which you should!) you can just add the following to your podfile and run `pod install`.

	pod 'CharlesTVDB', :git => 'https://github.com/simonbs/CharlesTVDB.git'
	pod 'AFKissXMLRequestOperation', :git => 'https://github.com/marcelofabri/AFKissXMLRequestOperation.git'

If you are not not using CocoaPods, you should clone this repository and copy CharlesTVDB/ directory into your project. You should also install [AFKissXMLRequestOperation](https://github.com/marcelofabri/AFKissXMLRequestOperation) which CharlesTVDB depends on.
**NOTE**: CharlesTVDB uses [Marcelo Fabris](https://github.com/marcelofabri) fork of AFKissXMLRequestOperation which supports AFNetworking 2.0.
You have to install the fork of AFKissXMLRequestOperation manually (e.g. using CocoaPods as shown above) as it is not possible to specify a fork as a dependency in a podspec.

AFKissXMLRequestOperation then again depends on  [AFNetworking](https://github.com/AFNetworking/AFNetworking) and [KissXML](https://github.com/robbiehanson/KissXML) so you will also have to install those.

When you have installed CharlesTVDB either using CocoaPods or not, you just need to import the header.  I recommend doing this in the prefix header.

	#import "CharlesTVDB"

You're ready to use CharlesTVDB!

## Usage

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

## Demo Projects

The two demo projects that are in this repository are very boring and are in no way complete. I will make some more interesting examples when I get some more time. However, the above description should give you plenty information on how to use CharlesTVDB.

## Credits

CharlesTVDB is developed by [@simonbs](http://twitter.com/simonbs), [simonbs.dk](http://simonbs.dk) Feel free to fork the repository and send pull requests if you have made something awesome.

## License

CharlesTVDB is released under the MIT license. Please see the LICENSE file for more information.