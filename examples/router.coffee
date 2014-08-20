{View, Router} = require './mvstar'

ImageView = View
  model:    Image
  template: '<img>'

SearchView = View
  template: ->
    '''
    <form>
      <input name="q" required>
      <input type="submit" value="search">
    </form>
    '''

Home = AppView
  views:
    SearchView:  '#search-view'
    BrowserView: '#content'
    FooterView:  '#footer-view'

Profile = App
  views:
    SearchView:  '#search-view'
    UserView:    '#content'
    FooterView:  '#footer-view'

Gallery = App
  views:
    SearchView:  '#search-view'
    ImageView:   '#content'
    FooterView:  '#footer-view'

router = Router
  '/':        Home
  '/gallery': Gallery
  '/profile': Profile

router.start()
