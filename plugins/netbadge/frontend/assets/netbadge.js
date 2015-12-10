$(function () {
   // since there is no way to sign out of netbadge short of closing out the browser,
   // remove the logout link (if it exists). Get the user dropdown menu...
   var dropdownItems = $("li.user-container .dropdown-menu.pull-right li");
   if ( dropdownItems.length > 0 ) {
      // ...remove the last two items (logout link and divider)
      var lastIdx = dropdownItems.length-1;
      dropdownItems.get( lastIdx ).remove();
      dropdownItems.get( lastIdx-1 ).remove();
   }
});
