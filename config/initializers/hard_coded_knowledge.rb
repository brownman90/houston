# Eventually we should get rid of this, of course.
# But, for now, this file documents a few things 
# we've scattered throughout the code base and need
# to abstract.
module Houston
  module TMI
    
    NAME_OF_DEPLOYMENT_FIELD = "Fixed in"
    FIELD_USED_FOR_LDAP_LOGIN = "samaccountname"
    INSTRUCTIONS_FOR_LOGIN = "You can log in with your CPH domain account"
    TICKET_LABELS_FOR_MEMBERS = [
      'Admin',
      'Global',
      'What\'s New',
      'Help',
      'Feedback',
      'Overview',
      'Overview / Upcoming Events',
      'Overview / Notifcations',
      'Overview / Data Health',
      'Overview / Recent Attendance',
      'Reports',
      'Reports / Annual Report',
      'Trends',
      'Trends / Export',
      'Trends / Print',
      'Trends Detail',
      'Trends Detail / Export',
      'Trends Detail / Print',
      'People',
      'People / Export',
      'People / Print',
      'Profile',
      'Profile / Photo',
      'Profile / General',
      'Profile / Family',
      'Profile / Attendance',
      'Profile / Offering',
      'Profile / Notes',
      'Profile / Pastoral Visits',
      'Profile / Export',
      'Mailing Labels',
      'Church Directory',
      'Add/Remove Tags',
      'Send Email',
      'Contribution Statements',
      'Households',
      'Households / Export',
      'Households / Print',
      'Household',
      'Household / Photo',
      'Household / General',
      'Household / Members',
      'Household / Notes',
      'Household / Pastoral Visits',
      'Smart Groups',
      'Tags',
      'Pastoral Visits',
      'New Person',
      'New Person / vCard',
      'Events',
      'Events / Print',
      'Event',
      'Event / Anniversary',
      'Calendars',
      'Enter Attendance',
      'Enter Offerings',
      'Enter Offerings / Export',
      'Envelopes',
      'Funds',
      'Pledges',
      'Settings',
      'Logins',
      'Permisssions',
      'Sunday School',
      'SS Import'
    ].freeze
    TICKET_LABELS_FOR_UNITE = [
      'Global',
      'Admin Bar',
      'Setup',
      'Help',
      'Search',
      'Feedback',
      'Login',
      'Pages',
      'Pages / New Page',
      'Page / Settings',
      'Page / Layouts',
      'Page / Edit Mode',
      'Feed',
      'Feed / Settings',
      'Feed / Post',
      'Posts',
      'Comments',
      'Members',
      'Users',
      'Users / Invite',
      'Users / Edit',
      'User / Settings',
      'User / Profile',
      'Profile',
      'Profile / Portrait',
      'Profile / Edit',
      'Profile / Groups',
      'Profile / Recent Activity',
      'Calendar',
      'Event',
      'Event / New',
      'Event / Edit',
      'Event / Discussion',
      'Event / Participants',
      'Groups',
      'Group / New',
      'Group / Discussion',
      'Group / Events',
      'Group / Members',
      'Group / Edit',
      'Group / Settings',
      'Themes / Browse',
      'Themes / Customize',
      'Themes / Advanced',
      'Themes / All',
      'Theme / Earthtones',
      'Theme / Heritage',
      'Theme / Minimal',
      'Theme / Modern',
      'Theme / Ribbon',
      'Theme / Swatch',
      'Theme / Urban',
      'Theme / Vertical',
      'Settings / Account',
      'Settings / Calendar',
      'Settings / Domain',
      'Settings / Google Analytics',
      'Settings / Integration',
      'New Feature',
      'CKEditor',
    ].freeze
    
  end
end
