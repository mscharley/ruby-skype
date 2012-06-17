
class Skype
  module DataMaps
    # Data mapping between user visibilities as returned by Skype and the symbols that this API cares about.
    USER_VISIBILITY = {
        :unknown => 'UNKNOWN',
        :online => 'ONLINE',
        :offline => 'OFFLINE',
        :skype_me => 'SKYPEME',
        :away => 'AWAY',
        :not_available => 'NA',
        :do_not_disturb => 'DND',
        :invisible => 'INVISIBLE',
        :logged_out => 'LOGGEDOUT',
    }
  end
end
