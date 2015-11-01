Conscrip is a standalone web app designed to act as a graphical interface for the CADjs design suite developed by Krishnan Suresh.

##Usage
Keyboard shortcuts:
  . Enters node placement mode
  l Enters edge placement mode
  p Enters path placement mode
  Esc Enters selection mode

##Development
Be sure that you have an understanding of either coffeescript or javascript before reading through the source code of Conscrip. Before beginning development, make sure bundle is installed, then install the required pacakges from the project root directory with

`bundle install`

Before beginning a development session, begin guard with

`bundle exec guard -d`

This will guarentee that coffeescript is continuously compiled into javascript to avoid asymmetry. In future iterations, development in js with continuous compilation into coffee will be supported.

Please be sure to write coffeescript comments in multi-line form, i.e.

`### Your comment here ###`

To guarentee that they are transferred into js.