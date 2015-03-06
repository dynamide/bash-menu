


================================================================================
  Use RestReplay to hit the github API to render our README.md file
================================================================================
                                                                      2015-02-20
pushd ~/.bash-menu/tests/restreplay

restreplay -d . -c githubapi/markdown.xml -g main -t markdown


