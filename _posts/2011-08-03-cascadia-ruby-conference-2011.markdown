--- 
layout: post
title: Cascadia Ruby Conference 2011
date: 2011-08-03 09:25:30
---

Last week I attended the [Cascadia Ruby 2011][cascadia] conference in Seattle. This event seems to be part of a growing trend of regional conferences. It's great to go to a conference like this without the time and expense of traveling.

I enjoyed the conference very much. As always, some sessions were much better than others. Overall, the quality was high and the enthusiasm for the event was great. I'm not doing as much Ruby or Rails at work as I'd like (too much Python lately). Part of my motivation was to keep plugged into the Ruby community since that's where I want to be and what I want to work with.

I was a little surprised at how many talks were not particularly technical. Frankly, it was a little uncomfortable how personal some of the stories were. If anything, it seems to point to some issues for developers overall that aren't being discussed. There were some lessons to learn but I wasn't in that mode and I think the impact of those presentations was a little lost on me.

I'll highlight some of the talks I found particularly good. I've embedded the videos that are available (courtesy of [Confreaks][confreaks]). I'll edit this post to add missing videos as the come available. If you want to see all the available talks, go to the [Cascadia event page][cascadia_event_confreaks].

# Shipping at the Speed of Life - Corey Donohoe

[Corey Donohoe][atmos] of [GitHub][github] gave a very entertaining talk on techniques they use to manage a large number of deployments and constant churn. At the heart of it is automation. They have developed a smart agent called Hubot. Using tools like [Campfire][campfire], they are able to send conversational messages to get status, start deployments, and otherwise interact with their production systems.

I've done things like this in the past with systems I've built (although no where near the scale of GitHub). I think the advantage is reducing human error by encapsulating work into consumable components. The danger of course is getting lost in building the automation tools. It's very seductive to keep adding more tasks to the automation handlers.

<div class='video'>
    <div class='video-player'>
    <video id="html5-player" width="640" height="480" controls="controls" preload="none" poster="http://confreaks.net/system/videos/images/608/preview/vlcsnap-2011-07-30-13h31m49s94.png?1312057979">
        <source src="http://confreaks.net/system/assets/datas/1726/original/608-cascadiaruby2011-shipping-at-the-speed-of-life-small.mp4" type="video/mp4" />
        Your browser does not support the video tag.
    </video>
    </div>
    <div class='video-title'>
    <a href="http://confreaks.net/videos/608-cascadiaruby2011-shipping-at-the-speed-of-life?player=html5">Shipping at the Speed of Life</a>
    </div>
    <div class='video-presenters'>
    <a href="http://confreaks.net/presenters/63-corey-donohoe">Corey Donohoe</a>
    </div>
    <div class='video-note'>
    Source: <a href="http://confreaks.net">Confreaks</a>
    </div>
</div>

# Confident Code - Avdi Grimm

[Avdi Grimm][avdi] did a presentation <strike>inspired by his book <a href="http://exceptionalruby.com">Exceptional Ruby</a></strike> on using assertive coding techniques. He included a [sample project][cowsay] that demonstrated many techniques for reducing code cruft like constantly checking for nil, using Decorator patterns, and applying pre-conditions. I'm definitely going to pick up his book. There were many great tips in the talk. I'm a big fan of streamlining error checking so that the code is of positive nature with negative cases filtered out.

<div class='video'>
    <div class='video-player'>
    <video id="html5-player" width="640" height="480" controls="controls" preload="none" poster="http://confreaks.net/system/videos/images/614/preview/vlcsnap-2011-08-02-20h59m34s58.png?1312346854">
        <source src="http://confreaks.net/system/assets/datas/1780/original/614-cascadiaruby2011-confident-code-small.mp4" type="video/mp4" />
        Your browser does not support the video tag.
    </video>
    </div>
    <div class='video-title'>
    <a href="http://confreaks.net/videos/614-cascadiaruby2011-confident-code?player=html5">Confident Code</a>
    </div>
    <div class='video-presenters'>
    <a href="http://confreaks.net/presenters/378-avdi-grimm">Avdi Grimm</a>
    </div>
    <div class='video-note'>
    Source: <a href="http://confreaks.net">Confreaks</a>
    </div>
</div>

# The Unix Chainsaw - Gary Bernhardt

[Gary Bernhardt][garybernhardt] was probably the most entertaining talk of the conference. Gary's core premise - Unix hasn't killed anyone (yet). So you should learn it and love it. He gave several examples of the power of putting together shell actions. He also wisely addressed the notion that these are often "half assed" solutions. However, as he repeated over and over, it's the right part of the ass.

Gary also announced he is now fulltime on a new company [Destroy All Software][destroyallsoftware]. His company will feature screencasts and learning tools for Unix in the spirit of [Railscasts][railscasts] or [PeepCode][peepcode]. It should be a very useful resource.

<div class='video'>
    <div class='video-player'>
    <video id="html5-player" width="640" height="480" controls="controls" preload="none" poster="http://confreaks.net/system/videos/images/615/preview/vlcsnap-2011-08-02-21h00m17s170.png?1312344106">
        <source src="http://confreaks.net/system/assets/datas/1783/original/615-cascadiaruby2011-the-unix-chainsaw-small.mp4" type="video/mp4" />
        Your browser does not support the video tag.
    </video>
    </div>
    <div class='video-title'>
    <a href="http://confreaks.net/videos/615-cascadiaruby2011-the-unix-chainsaw?player=html5">The Unix Chainsaw</a>
    </div>
    <div class='video-presenters'>
    <a href="http://confreaks.net/presenters/429-gary-bernhardt">Gary Bernhardt</a>
    </div>
    <div class='video-note'>
    Source: <a href="http://confreaks.net">Confreaks</a>
    </div>
</div>

# Powerful (but Easy) Data Visualization with the Graph Gem - Aja Hammerly

[Aja Hammerly][kushali] demonstrated how to use the graph gem with [Graphviz][graphviz]. It was probably not something I would think I would be interested in. But between Aja's enthusiasm and all the cool things she did with it, I definitely want to look at using it. Aja showed how her company uses graphs to visualize workflows and states. Graphviz is about graphs in the computer science sense. The gem can generate DOT files (the format for Graphviz). The Ruby library was a little different in that it was a lot like the fixed function pipeline style of say OpenGL. But it makes sense.

It's always very enlightening to see complex structures visually. I use graphical tools for Git frequently to better understand what is going on. It makes sense to use these for your own workflows as well.

<div class='video'>
    <div class='video-player'>
    <video id="html5-player" width="640" height="480" controls="controls" preload="none" poster="http://confreaks.net/system/videos/images/617/preview/vlcsnap-2011-08-05-00h49m20s232.png?1312530716">
        <source src="http://confreaks.net/system/assets/datas/1801/original/617-cascadiaruby2011-powerful-but-easy-data-visualization-with-the-graph-gem-small.mp4" type="video/mp4" />
        Your browser does not support the video tag.
    </video>
    </div>
    <div class='video-title'>
    <a href="http://confreaks.net/videos/617-cascadiaruby2011-powerful-but-easy-data-visualization-with-the-graph-gem?player=html5">Powerful (but Easy) Data Visualization with the Graph Gem</a>
    </div>
    <div class='video-presenters'>
    Aja Hammerly
    </div>
    <div class='video-note'>
    Source: <a href="http://confreaks.net">Confreaks</a>
    </div>
</div>

# Size Doesn't Matter, or: The ins and outs of Minitest - Ryan Davis

[Ryan Davis][ryan] presented a very nice tour of [Minitest][minitest]. Let me be upfront - I dislike [RSpec][rspec] and I **hate** [Cucumber][cucumber]. Both are very "magical". RSpec makes more sense to me but I don't find that the syntax is any more useful than xUnit. Cucumber is conceptually an interesting idea. But in practice, I've found it to be very difficult to build tests let alone understand what is going on.

Ryan highlighted some of the same things in his talk. Minitest is very transparent. It's not hard to see what it is doing. As Ryan pointed out, the goal is to get the failures as close to your code as possible. I completely agree with that philosophy.

Minitest does support RSpec-style BDD syntax so it seems poised to work equally well for xUnit and BDD testing. I like that it is (or going to be?) part of the Ruby distribution. I was a little confused on if I need to do anything to get it under Ruby 1.9.x/Rails 3.

One other item that Ryan touched on was the use of mocks. He asserted that mocks should be a last resort and at the highest level possible. That seems like good advice. I try to use mocks for external services. One thing I would love to follow up on though is how to construct your code to support mocks in the correct sense. Do you design models that use a data source pattern so that you can use a mock service instead? Many times I've written my code as a wrapper to a service and backed myself into a corner when it came to mocking the service.

<div class='video'>
    <div class='video-player'>
    <video id="html5-player" width="640" height="480" controls="controls" preload="none" poster="http://confreaks.net/system/videos/images/618/preview/vlcsnap-2011-08-05-00h51m16s98.png?1312531034">
        <source src="http://confreaks.net/system/assets/datas/1804/original/618-cascadiaruby2011-size-doesn-t-matter-small.mp4" type="video/mp4" />
        Your browser does not support the video tag.
    </video>
    </div>
    <div class='video-title'>
    <a href="http://confreaks.net/videos/618-cascadiaruby2011-size-doesn-t-matter?player=html5">Size Doesn't Matter</a>
    </div>
    <div class='video-presenters'>
    <a href="http://confreaks.net/presenters/20-ryan-davis">Ryan Davis</a>
    </div>
    <div class='video-note'>
    Source: <a href="http://confreaks.net">Confreaks</a>
    </div>
</div>

# Code and Creativity - Geoffrey Grossenbach

[Geoffrey Grossenbach][topfunky] closed the conference with a presentation on coding related to creativity. I think Geoffrey approaches his craft more like an artist. Unstructured time allows information to be processed and ideas to form. He encouraged you to not feel like that time was wasted. Making connections needs space to form.

There is a conflict between the artist and the engineer in our profession. So much of what we do is pure creativity. Yet it often feels like it is not encouraged. Geoffrey discussed sources of inspiration, managing the creative process, and embracing the ebb and flow of creativity.

It's easy to listen to Geoffrey and think "of course he can do that, he's got freedom I don't have". That may be true. But I think that the advice applies to anyone. Applying creative techniques as much as you can is entirely worthwhile. You might just have to be creative in embracing your creativity.

<div class='video'>
    <div class='video-player'>
    <video id="html5-player" width="640" height="480" controls="controls" preload="none" poster="http://confreaks.net/system/videos/images/621/preview/vlcsnap-2011-08-07-16h44m18s12.png?1312760843">
        <source src="http://confreaks.net/system/assets/datas/1839/original/621-cascadiaruby2011-code-and-creativity-small.mp4" type="video/mp4" />
        Your browser does not support the video tag.
    </video>
    </div>
    <div class='video-title'>
    <a href="http://confreaks.net/videos/621-cascadiaruby2011-code-and-creativity?player=html5">Code and Creativity</a>
    </div>
    <div class='video-presenters'>
    <a href="http://confreaks.net/presenters/431-geoffrey-grossenbach">Geoffrey Grossenbach</a>
    </div>
    <div class='video-note'>
    Source: <a href="http://confreaks.net">Confreaks</a>
    </div>
</div>
  
----

- ***Updated 08.04.2011 21:15*** -- Added Confident Code and The Unix Chainsaw video links.  
- ***Updated 08.04.2011 22:25*** -- Confident Code is not based on the Exceptional Ruby book.  
- ***Updated 08.05.2011 13:49*** -- Added Easy Data Visualization with Graph and Size Doesn't Matter video links.  
- ***Updated 08.08.2011 08:06*** -- Added Code and Creativity video links.

[cascadia]: http://cascadiarubyconf.com/
[confreaks]: http://confreaks.net/
[cascadia_event_confreaks]: http://confreaks.net/events/cascadiaruby2011
[github]: http://github.com
[campfire]: http://campfirenow.com/
[exceptional_ruby]: http://exceptionalruby.com/
[cowsay]: https://github.com/avdi/cowsay
[destroyallsoftware]: http://destroyallsoftware.com/
[railscasts]: http://railscasts.com
[peepcode]: http://peepcode.com
[graphviz]: http://www.graphviz.org/
[minitest]: http://bfts.rubyforge.org/minitest/
[rspec]: http://rspec.info/
[cucumber]: http://cukes.info/
[atmos]: http://twitter.com/atmos
[avdi]: http://twitter.com/avdi
[garybernhardt]: http://twitter.com/garybernhardt
[kushali]: http://twitter.com/kushali
[ryan]: http://blog.zenspider.com/
[chadfowler]: http://twitter.com/chadfowler
[topfunky]: http://twitter.com/topfunky
