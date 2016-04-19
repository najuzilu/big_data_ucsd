# usage : python LiveTweets.py keyword

import json
from tweepy.streaming import StreamListener
from tweepy import OAuthHandler, Stream
from login import *

class TweetStreamListener(StreamListener):
    def on_data(self, data):
        tweet = json.loads(data)
        print "\n||" + tweet["created_at"][4:-10] + "|| " + tweet["text"][:65]
        return True
    
    def on_error(self, status):
        print status

listener = TweetStreamListener()
auth_key = OAuthHandler(consumer_key, consumer_secret)
auth_key.set_access_token(access_token, access_token_secret)
live_twitter_stream = Stream(auth_key, listener)
live_twitter_stream.filter(track=[arg])