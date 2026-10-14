class Object
    def as
        self
    end
end

require_relative '../models/copy'
require_relative '../models/ark_iota'
require_relative '../models/bad_photo'
require_relative '../models/guestbook'

require_relative '../helpers/simple_web'
require_relative '../helpers/markdown'
require_relative '../helpers/content'
require_relative '../helpers/forest'
require_relative '../helpers/cipher'
require_relative '../helpers/cdn'
require_relative '../helpers/diary'
require_relative '../helpers/programming_challenges'

require_relative '../routes/blog'
require_relative '../routes/system'
require_relative '../routes/spam'
require_relative '../routes/robots'
require_relative '../routes/session'
require_relative '../routes/guestbook'
require_relative '../routes/astrology'
require_relative '../routes/projects'
require_relative '../routes/time'
require_relative '../routes/rss'
require_relative '../routes/garmin'