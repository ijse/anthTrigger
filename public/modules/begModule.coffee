angular.module('anthTrigger')
.factory 'begService', ($rootScope)->

  # Things not allowed to do
  BanList = {
    'admin': { test: -> false }
    'manager': ///^(
          \/users$|
          view_userManage
        )$///
    'tester': ///^(
          \/users$|
          view_userManage|
          script_add|
          script_edit
        )$///
  }

  return {
    beg: (th)->
      user = $rootScope.CurrentUser
      return false if not user
      return BanList[user.role].test(th)
  }

.directive 'beg', (begService)-> {
  restrict: 'A'
  link: (scope, elem, attrs)->
    thing = attrs.beg
    hidden = attrs.begHide
    NO = begService.beg(thing)
    elem.hide() if NO
    elem.attr('disabled', 'disabled') if NO
}