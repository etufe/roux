---
layout: post
title:  "The Perfect Static Blog"
subtitle: "I'm not writing all this crap"
categories: jekyll blogging
---

## What a time to be alive.
The mass of tools that other people have written to enable the quiet ramblings of the internet is impressive. There must be tens of thousands of lines of open source code fueling this modest, static blog but we're only 2 sentences in and I digress.

Let's set up the perfect toolchain for running a Jekyll based blog.<br>
Here's what we want:

 - Compose posts in Markdown
 - [Github Flavored markdown][ghfmd] that is
 - Compile the site through [Jekyll][jek]
 - Syntax highlighting through [Pygments][pyg]
 - Auto [Coffeescript][coffee] compilation
 - Auto [Sass][sass] compilation
 - [HTML5 Boilerplate][htmlb]
 - Live site preview as we develop/write
 - RSS Syndication
 - Pusbutton deployment
 - Free hosting through [GitHub Pages][ghp]
 - Sexy custom domain

 **And Most Importantly:**

 - To do as little work as humanly possible

## It's 2015
I'm not writing all this crap, let's use a project that has already solved most of these problems. The [jekillrb](https://github.com/robwierzbowski/generator-jekyllrb) generator for the fantastic [Yeoman](http://yeoman.io/) web scaffolding tool fits the bill. We're gonna cross out most of our todos with this one tool. Let's set it up.

**First**, Get your self a nodejs environment. If your system has a package manager, use that. Otherwise you can get the instaler direct from the source here: http://nodejs.org/ . Already have node? **Update it**! Either using your package manager or just running the most recent intsaller will safely upgrade you to the latest and greatest.

**Second**, Get yourself a ruby environment >= 1.8. On Mac or Linux? You've probably already got one that'll work. Otherwise follow the instructions here: https://www.ruby-lang.org/en/documentation/installation/

**Third**, Install jekyll: `gem install jekyll`

**Fourth**, install yeoman: `sudo npm install -g yeoman`

Running `which yo` after install will prove you`ve got it installed correctly.

**Fifth**, install the jekyllrb generator:<br>
`sudo npm install -g generator-jekyllrb`

### Optional:

**Want syntax highlighting?** Set up a python >= 2.7 and < 3 environment. On Mac/Linux? Chances are you've already got one good enough. Run `python --version` from the command line to check. Grab the installer from here: https://www.python.org/downloads/ if not. Once you have python installed, run `pip install Pygments` and we're good to go!

**Want free hosting?** Create a repo for this project at github.com. We're gonna use `grunt-bild-control` to automatically push our built site to a [gh-pages][ghp] site and use github`s free hosting.

## You had me at yo jekyllrb

All right let's get this show on the road. With all the tools installed all we have left is to actually generate the site.
{% highlight text %}
mkdir my-blog
cd my-blog
yo jekyllrb  # <- where the magic happens
{% endhighlight %}

Fill in the obvious options selecting sass, coffescript and HTML5 Boilerplate if you like. **If you plan on deploying your blog to a git repository** make sure to answer **yes** to `Use grunt-build-control for deployment?`. If you're going to use GitHub Pages, set the `remote` to your github repo path and the `branch` to `gh-pages`.

I prefer the `pretty` Post Permalink style, it includes your posts categories in the url. For the markdown library choose `redcarpet` simply because it does the best job of supporting [GitHub Flavored Markdown][ghfmd]. For code highlighting answer yes to Pygments. In order for it to work you must have python and Pygments installed as mentioned earlier.

Once generation is complete get all your JS dependencies with:

{% highlight text %}
bower install & npm install
{% endhighlight %}

## Crossing the T's

That just about does all the work for us. Our laundry list of features has been mostly knocked out with that one command. Let's look at what we have left of the original list:

 - Github flavored Markdown
 - Syntax Highlighting
 - RSS Syndication
 - Sexy custom domain

**Github flavored Markdown** We can't get 100% there but we can get a respectable 90. In your `_config.yml` file make sure the markdown section looks like:
{% highlight yaml %}
# Markdown library
markdown: redcarpet
redcarpet:
  extensions: ["no_intra_emphasis", "tables", "autolink",
    "strikethrough", "with_toc_data", "fenced_code_blocks",
    ":disable_indented_code_blocks", "underline",
    "highlight","footnotes"]
{% endhighlight %}

I haven't gotten fenced code blocks to work perfectly so you're gonna have to specify them as defined in the jekyll docs:

**&lbrace;% highlight ruby linenos %}**<br>
Code goes here<br>
**&lbrace;% endhighlight %}**

**Syntax Highlighting** The bulk here is actually done we just don't have a stylesheet for the syntax colors yet. If you're using pygments this command will take care of that: 
{% highlight text %}
pygmentize -S monokai -f html > app/css/syntax.css
{% endhighlight %}

**RSS Syndication** Jekyll will render any files in your `app/` directory so all you have to do is copy the `feed.xml` file from this repo: https://github.com/snaptortoise/jekyll-rss-feeds into your `app/` directory and you're good to go. Make sure your `_config.xml` file has the `title`, `description`, and `url` properties or edit them out of your `feed.xml` file.

**Sexy custom domain** Follow these instructions if you're using github: https://help.github.com/articles/setting-up-a-custom-domain-with-github-pages/. Place the `CNAME` file in `app/` and you're good to go!

## Tool Time
Your workflow now consists of a few convenient commands.

 - `grunt serve`: Will build, serve, and live reload your site for local development.
 - `grunt`: Run your site through linters and check the build.
 - `grunt build`: Create the distributable blog in `dist/`.
 - `grunt deploy`: If you`re using grunt-buid-control this single command with check, test, build and push your blog live!
 
## That's it, we're good
What used to take hours, now takes minutes. No database, no users, no hosting fees, no programming just you and your endless inspiration. Go out for a stroll and think about how far we've come as a civilation and the places technology might take us. If we can put a man on the moon we surely don't need to code any of this crap[^1]! And by golly we didn't. <br>
&#9876;



<!-- Refs -->
[pyg]: http://pygments.org/
[jek]: http://jekyllrb.com/
[coffee]: http://coffeescript.org/
[sass]: http://sass-lang.com/
[htmlb]: https://html5boilerplate.com/
[ghfmd]: https://help.github.com/articles/github-flavored-markdown/
[ghp]: https://pages.github.com/

<!-- Footnotes -->
[^1]: JK we put a man on the moon before the internet existed.
