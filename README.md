# Introduction

CtrlR faithfully emulates the reverse search functionality found in the Bourne-again shell because, well, I couldn't vim without it anymore. My every ^P just screamed for ^R.

But how could I bind it to that key when it already does register insertion? By default, if you press ^R with an empty command line, the reverse-i-search will be brought up, whereas if you have typed anything, the native action will be executed. This should be mostly intuitive since bash's own reverse search ignores anything you have typed so far when you invoke it (just earlier today while using ^R in bash I got why that is a brilliant feature, but now I can't seem to remember.)
