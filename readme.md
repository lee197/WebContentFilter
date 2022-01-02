
# WebContentFilter

An app to fetch web content, process the content  and display the result.

## Branches:

* master - stable app releases

## Dependencies:

The project is not using any third party cocoapods for managing external libraries

## Project structure:

* ViewController: Including all the views and view logic (binding ViewModel).
* ViewModel: Providing logics ViewController needs
* WebContentProcessor: Logics for processing the web content
* WebContentService: Fetch the web content and pass it to ViewModel
* Uint test: test the all functions in ViewModel WebContentProcessor with mocked networking service

## Next step:

*  Improve the code naming 
*  Unit test errors from ViewModel 
*  Improve UI and try to replace the storyboard with Autolyout
* Move all the hardcoded strings to Constant Class
* Add a loading view to provide a better constumer experience

## Author:

*  Qi Li

## Contact:

* https://www.linkedin.com/in/lee-qi/
