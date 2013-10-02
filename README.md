# Introduction [![Flattr this plugin](http://api.flattr.com/button/flattr-badge-large.png)](https://flattr.com/submit/auto?user_id=goldfeld&url=https://github.com/goldfeld/ctrlr.vim&title=ctrlr.vim&language=en&tags=github&category=software)

CtrlR faithfully emulates the reverse search functionality found in the Bourne-again shell because, well, I couldn't vim without it anymore. My every ^P just screamed for ^R.

But how could I bind it to that key when it already does register insertion? By default, if you press ^R with an empty command line, the reverse-i-search will be brought up, whereas if you have typed anything, the native action will be executed. This should be mostly intuitive since bash's own reverse search ignores anything you have typed so far when you invoke it (just earlier today while using ^R in bash I got why that is a brilliant feature, but now I can't seem to remember.)

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/goldfeld/ctrlr.vim/trend.png)](https://bitdeli.com/free "Bitdeli Badge")
